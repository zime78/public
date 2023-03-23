//
//  MessageManager.swift
//  watchTest
//
//  Created by zimeVX on 2023/03/14.
//

import Foundation
import WatchConnectivity


@objc
class FileTransferManager: NSObject {
    
    private let fileTransferObservers = FileTransferObservers()
    @objc public static let shared = FileTransferManager()

    
    override init() {
        super.init()
    }
    
    @objc
    func load() {
    }
    
    // document Directory 위치 반환
    //
    private var folderURL: URL! {
        let folderURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
//        folderURL.appendPathComponent("Logs")
        
        if !FileManager.default.fileExists(atPath: folderURL.path) {
            do {
                try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
            } catch {
                print("Failed to create the log folder: \(folderURL)! \n\(error)")
                return nil // To trigger crash.
            }
        }
        return folderURL
    }
    
    //압축할 zip파일이름
    private var zipFileName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmm" //"yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: Date())
        return "\(dateString)_logFiles.zip"
    }
    
    
    // document + 압축파일 위치 반환함.
    //
    private var fileURL: URL! {
        let rootURL: URL = folderURL
        var fileURL: URL = rootURL
        fileURL.appendPathComponent(zipFileName) //압축파일이름 가지고옴

        if !FileManager.default.fileExists(atPath: fileURL.path) {
            if !FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil) {
                print("Failed to create the log file: \(fileURL)!")
                return nil // To trigger crash.
            }
        }
        print("fileURL: \(fileURL)")
        return fileURL
    }
    
    
    //테스트로 저장된 로그 파일 폰으로 전송함.
    @objc
    func onTest(){
        let zipFileName = zipFileName
        
        let rootURL: URL = folderURL
        var fileURL: URL = rootURL
        fileURL.appendPathComponent(zipFileName) //20230301_logFiles.zip
        
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            if !FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil) {
                print("Failed to create the log file: \(fileURL)!")
                return // To trigger crash.
            }
        }
        print("fileURL: \(fileURL)")
        
        //1.파일 압축함.
#if os(watchOS)
        //공용함수내 워치에 있는 class이므로 define으로 처리함(해제시 컴파일 오류 발생됨)
        ExpansionObj.onCompressLogZip(zipFileName)
#endif
                
        //2. 압축파일 전송
        onSendLogFiles(file: fileURL)
    }
    
    
    @objc
    func onSendLogFiles(file: URL){
        //저장되어있는 로그파일 전송함.
        guard WCSession.default.activationState == .activated else {
            return
        }
        
        var commandStatus = CommandStatus(command: .transferFile, phrase: .transferring)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        let timeString = dateFormatter.string(from: Date())
        let metadata: [String: Any] = [PayloadKey.timeStamp: timeString, PayloadKey.message: "msg".data(using: .utf8) as Any]

        
        commandStatus.fileTransfer = WCSession.default.transferFile(file, metadata: metadata)
        
        //파일전송 관리 >> 취소와 상태를 알수있음.
        fileTransferObservers.observe(commandStatus.fileTransfer ?? WCSessionFileTransfer.init()) { _ in
            FileTransferManager.logProgress(for: commandStatus.fileTransfer ?? WCSessionFileTransfer.init())
        }
    }
    
    //파일 전송 진행 사항
    @objc
    public static func logProgress(for fileTransfer: WCSessionFileTransfer) {
        DispatchQueue.main.async {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .medium
            let timeString = dateFormatter.string(from: Date())
            let fileName = fileTransfer.file.fileURL.lastPathComponent
            
            print(">>>>> ", timeString, fileName)
        }
    }
    
    @objc
    func unobserve(fileTransfer: WCSessionFileTransfer){
        fileTransferObservers.unobserve(fileTransfer)
    }
}

