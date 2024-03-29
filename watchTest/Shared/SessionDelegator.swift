//
//  SessionDelegator.swift
//  watchTest
//
//  Created by zimeVX on 2023/03/12.
//

import Foundation
import WatchConnectivity

#if os(watchOS)
import ClockKit
#endif

// Custom notifications happen when Watch Connectivity activation or reachability status changes,
// or when receiving or sending data. Clients observe these notifications to update the UI.
//
extension Notification.Name {
    static let dataDidFlow              = Notification.Name("DataDidFlow")
    static let activationDidComplete    = Notification.Name("ActivationDidComplete")
    static let reachabilityDidChange    = Notification.Name("ReachabilityDidChange")
}


// Implement WCSessionDelegate methods to receive Watch Connectivity data and notify clients.
// Handle WCSession status changes.
//
class SessionDelegator: NSObject, WCSessionDelegate {
    
    // MARK: -
    // MARK: Managing Session Activation
    // MARK: -
    // Monitor WCSession activation state changes.
    //
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        postNotificationOnMainQueueAsync(name: .activationDidComplete)
    }
    
    // WCSessionDelegate methods for iOS only.
    //
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("\(#function): activationState = \(session.activationState.rawValue)")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // Activate the new session after having switched to a new watch.
        session.activate()
    }
    #endif
    
    
        
    // MARK: -
    // MARK: Managing State Changes
    // MARK: -
    #if os(iOS)
    func sessionWatchStateDidChange(_ session: WCSession) {
        print("\(#function): activationState = \(session.activationState.rawValue)")
    }
    #endif
    
    // Monitor WCSession reachability state changes.
    //
    func sessionReachabilityDidChange(_ session: WCSession) {
        postNotificationOnMainQueueAsync(name: .reachabilityDidChange)
    }
    
    //Indicates a change to the companion app’s installed state.
    //
    #if os(watchOS)
    func sessionCompanionAppInstalledDidChange(_ session: WCSession){
        if session.isCompanionAppInstalled {
            print("iOS app 설치 되었습니다.")
        } else {
            print("iOS app 설치되지 않았습니다.")
        }
    }
    #endif
    
    

    // MARK: -
    // MARK: Receiving Context Data
    // MARK: -
    // Did receive an app context.
    //
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        var commandStatus = CommandStatus(command: .updateAppContext, phrase: .received)
        commandStatus.info = MessageInfo(applicationContext)
        postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)
    }
    
    

    // MARK: -
    // MARK: Receiving Immediate Messages
    // MARK: -
    // Did receive a message, and the peer doesn't need a response.
    //
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        
        if let logData = message[PayloadKey.log] as? Data {
            //Print는 콘솔 로그에 안찍힘
            print("[LOG] [wath -> phone]>> \(String(data: logData, encoding: .utf8) ?? " ")" )
            
            //콘솔 로그는 NSLog로해야 표시됨
            NSLog("[LOG] [wath -> phone]>> %@", String(data: logData, encoding: .utf8) ?? " ")
        }else {
            var commandStatus = CommandStatus(command: .sendMessage, phrase: .received)
            commandStatus.info = MessageInfo(message)
            postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)
            
            // 수신한 메시지 확인.
    //        let receivedMessage = message["message"] as? String ?? "No message received"
    //        let receivedTime = message["timeStamp"] as? String ?? "No Time received"
            //옵셔널 풀어야됨.
            //print("Received message: \(String(describing: commandStatus.info?.getMessage())) ::(\(String(describing: commandStatus.info?.getTimeStamp())))")

        }
        
        // 응답 메시지 작성
//        let replyMessage = ["replyKey": "Message received"]
        
        // 응답 핸들러 호출
//        replyHandler(replyMessage)
    }
    // Did receive a message, and the peer needs a response.
    //
    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        self.session(session, didReceiveMessage: message)
        replyHandler(message) // Echo back the time stamp.
    }
    
    // Did receive a piece of message data, and the peer doesn't need a response.
    //
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        var commandStatus = CommandStatus(command: .sendMessageData, phrase: .received)
        commandStatus.info = MessageInfo(messageData)
        postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)
    }
    
    // Did receive a piece of message data, and the peer needs a response.
    //
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        self.session(session, didReceiveMessageData: messageData)
        replyHandler(messageData) // Echo back the time stamp.
    }

    
    
    // MARK: -
    // MARK: Managing Data Dictionary Transfers
    // MARK: -
    // Did receive a piece of userInfo.
    //
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        var commandStatus = CommandStatus(command: .transferUserInfo, phrase: .received)
        commandStatus.info = MessageInfo(userInfo)
        
        if let isComplicationInfo = userInfo[PayloadKey.isCurrentComplicationInfo] as? Bool,
            isComplicationInfo == true {
            
            commandStatus.command = .transferCurrentComplicationUserInfo
            
            #if os(watchOS)
            let server = CLKComplicationServer.sharedInstance()
            if let complications = server.activeComplications {
                for complication in complications {
                    // Call this method sparingly.
                    // Use extendTimeline(for:) instead when the timeline is still valid.
                    server.reloadTimeline(for: complication)
                }
            }

            #endif
        }
        postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)
    }
    // Did finish sending a piece of userInfo.
    //
    func session(_ session: WCSession, didFinish userInfoTransfer: WCSessionUserInfoTransfer, error: Error?) {
        var commandStatus = CommandStatus(command: .transferUserInfo, phrase: .finished)
        commandStatus.info = MessageInfo(userInfoTransfer.userInfo)
        
        #if os(iOS)
        if userInfoTransfer.isCurrentComplicationInfo {
            commandStatus.command = .transferCurrentComplicationUserInfo
        }
        #endif

        if let error = error {
            commandStatus.errorMessage = error.localizedDescription
        }
        postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)
    }
    
    
    
    // MARK: -
    // MARK: Managing File Transfers
    // MARK: -
    
    // 파일을 받음.
    //
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        var commandStatus = CommandStatus(command: .transferFile, phrase: .received)
        commandStatus.file = file
        commandStatus.info = MessageInfo(file.metadata!)
        
        // The system removes WCSessionFile.fileURL once this method returns,
        // so dispatch to main queue synchronously instead of calling
        // postNotificationOnMainQueue(name: .dataDidFlow, userInfo: userInfo).
        //
        
        
        // 수신한 파일이 저장될 URL 경로 설정
        let documentsURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = documentsURL.appendingPathComponent(file.fileURL.lastPathComponent)
        
        // 수신한 파일을 저장
        do {
            try FileManager.default.moveItem(at: file.fileURL, to: fileURL)
            print("Received file: \(fileURL)")
        } catch {
            print("Error saving file: \(error.localizedDescription)")
        }
        
        postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)

    }
    
    // Did finish a file transfer.
    //
    func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
        var commandStatus = CommandStatus(command: .transferFile, phrase: .finished)

        if let error = error {
            commandStatus.errorMessage = error.localizedDescription
            postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)
            return
        }
        commandStatus.fileTransfer = fileTransfer
        commandStatus.info = MessageInfo(fileTransfer.file.metadata!)

//        #if os(watchOS)
//        Logger.shared.clearLogs()
//        #endif
        postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)
    }
    


    // MARK: -
    // MARK: Noti
    // MARK: -
    // Post a notification on the main thread asynchronously.
    //
    private func postNotificationOnMainQueueAsync(name: NSNotification.Name, object: CommandStatus? = nil) {
        print("noti:\(name.rawValue)")
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: name, object:["message": object?.info?.message])
        }
    }
    
}
