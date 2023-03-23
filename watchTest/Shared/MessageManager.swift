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
    
    private let fileTransferObservers = FileTransferObservers()
    
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
#if os(watchOS)
        //watch
        ExpansionObj.testLog("[watch] MessageManager load()")
#else
        //phone
        onTestMessage(msg: "[phone] MessageManager load()")
#endif
       
    }
    
    @objc
    func onTestMessage(msg: String){

        guard WCSession.default.activationState == .activated else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        let timeString = dateFormatter.string(from: Date())
        
        let item: [String: Any] = [PayloadKey.timeStamp: timeString, PayloadKey.message: msg.data(using: .utf8) as Any]
        WCSession.default.sendMessage(item, replyHandler: { replyMessage in
            //성공처리
        }, errorHandler: { error in
            //실패처리
        })
    }
    
    @objc
    func onTestInfoTranser(msg: String){
        
        guard WCSession.default.activationState == .activated else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        let timeString = dateFormatter.string(from: Date())
        
        let item: [String: Any] = [PayloadKey.timeStamp: timeString, PayloadKey.message: msg.data(using: .utf8) as Any]
        var commandStatus = CommandStatus(command: .transferUserInfo, phrase: .sent)
        commandStatus.userInfoTranser = WCSession.default.transferUserInfo(item)
    }
}

