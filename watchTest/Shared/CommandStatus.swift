/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Wraps the command status.
*/

import UIKit
import WatchConnectivity

//MessageInfo dictionary key정의
struct PayloadKey {
    static let timeStamp                 = "timeStamp"
    static let message                   = "message"
    static let isCurrentComplicationInfo = "isCurrentComplicationInfo"
}


// 명령내용
//
enum Command: String {
    case updateAppContext                    = "UpdateAppContext"
    case sendMessage                         = "SendMessage"
    case sendMessageData                     = "SendMessageData"
    case transferUserInfo                    = "TransferUserInfo"
    case transferFile                        = "TransferFile"
    case transferCurrentComplicationUserInfo = "TransferComplicationUserInfo"
}

// 상태정보
//
enum Phrase: String {
    case updated        = "Updated"     //업데이트됨
    case sent           = "Sent"        //전송됨
    case received       = "Received"    //받음
    case replied        = "Replied"     //응답
    case transferring   = "Transferring"
    case canceled       = "Canceled"    //취소
    case finished       = "Finished"    //완료
    case failed         = "Failed"      //실패
}

// messageInfo
//
struct MessageInfo {
    var timeStamp: String
    var message: Data
    
    var messageInfo: [String: Any] {
        return [PayloadKey.timeStamp: timeStamp, PayloadKey.message: message]
    }
    
    init(_ value: [String: Any]) {
        guard let timeStamp = value[PayloadKey.timeStamp] as? String,
            let messageData = value[PayloadKey.message] as? Data else {
                fatalError("Timed color dictionary doesn't have right keys!")
        }
        self.timeStamp = timeStamp
        self.message = messageData
    }
    
    init(_ value: Data) {
        let data = ((try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(value)) as Any??)
        guard let dictionary = data as? [String: Any] else {
            fatalError("Failed to unarchive a timedColor dictionary!")
        }
        self.init(dictionary)
    }
    
    // message 전달함.
    //
    func getMessage() -> String{
        if let receivedMessage = String(data: message, encoding: .utf8) {
            return receivedMessage
        } else {
            return "No message"
        }        
    }
    
    // 시간 정보 전달함.
    func getTimeStamp() -> String{
        return self.timeStamp
    }

}

// 정보.
//
struct CommandStatus {
    var command: Command
    var phrase: Phrase
    
    var info: MessageInfo?
    
    var fileTransfer: WCSessionFileTransfer?
    var file: WCSessionFile?
    var userInfoTranser: WCSessionUserInfoTransfer?
    
    var errorMessage: String?                       //오류Message
    
    //상태정보 설정
    init(command: Command, phrase: Phrase) {
        self.command = command
        self.phrase = phrase
    }
}
