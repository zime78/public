//
//  MessageManager.swift
//  watchTest
//
//  Created by zimeVX on 2023/03/14.
//

import Foundation
import WatchConnectivity


@objc
class MessageManager: NSObject {
    
    @objc public static let shared = MessageManager()
    
    private var sessionDelegator: SessionDelegator = {
        return SessionDelegator()
    }()
    
    override init() {
        super.init()
        assert(WCSession.isSupported(), "This sample requires a platform supporting Watch Connectivity!")
        
        WCSession.default.delegate = sessionDelegator
        WCSession.default.activate()
    }
    
    @objc
    func load() {
        
    }
    
    @objc
    func onTestMessage(msg: String){
//        var commandStatus = CommandStatus(command: .sendMessage, phrase: .sent)
//        commandStatus.timedColor = TimedColor(message)

        guard WCSession.default.activationState == .activated else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        let timeString = dateFormatter.string(from: Date())
        
        let item: [String: Any] = [PayloadKey.timeStamp: timeString, PayloadKey.message: msg.data(using: .utf8) as Any]
        
        // A reply handler block runs asynchronously on a background thread and should return quickly.
        WCSession.default.sendMessage(item, replyHandler: { replyMessage in
//            commandStatus.phrase = .replied
//            commandStatus.timedColor = TimedColor(replyMessage)
//            self.postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)

        }, errorHandler: { error in
//            commandStatus.phrase = .failed
//            commandStatus.errorMessage = error.localizedDescription
//            self.postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)
        })
        
    }
}
