//
//  ContentView.swift
//  watchos Watch App
//
//  Created by zimeVX on 2023/03/09.
//

import SwiftUI

struct ContentView: View {
    @State var infoMsg = "3"
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                
                Text(infoMsg)
            }
            
            ScrollView {
                Button(action: {
                    ExpansionObj.testLog("[watch]압축버튼 클릭")
                    ExpansionObj.onTestZip()
                }, label: {
                    Text("압축")
                })
                
                Button(action: {
                    ExpansionObj.testLog("[watch]메시지 전송클릭")
                    //phone와watch 같이 사용하는 함수 이용해서 메시지 전달함
                    ExpansionObj.testMessage("object-c로 메시지보내기")
                }, label: {
                    Text("obj 메시지")
                })
                
                Button(action: {
                    ExpansionObj.testLog("[watch]swift 메시지 전송클릭")
                    //phone와watch 같이 사용하는 함수 이용해서 메시지 전달함
                    MessageManager.shared.onTestMessage(msg: "watch test swift message")
                }, label: {
                    Text("swift 메시지")
                })
                
                Button(action: {
                    ExpansionObj.testLog("[watch]Log파일 보냄.")
                    //watch -> phone
                    FileTransferManager.shared.onSendWatchLogFile()
                    
                }, label: {
                    Text("log File보내기")
                })
            }.background(Color.orange)
                        
        }
        .onReceive(NotificationCenter.default.publisher(for: .dataDidFlow)) { notification in
            //Nofi 받아 처리 하기
            if let data = notification.object as? [String: Any] {                
                if let messageData = data["message"] as? Data {
                    infoMsg = String(data: messageData, encoding: .utf8) ?? " "
                }else{
                    infoMsg = "err message change"
                }
            }else {
                infoMsg = "err object change"
            }
                
            print("My event received!")
        }
        .onAppear(){
                //Session 초기화(연결함)
                MessageManager.shared.load()
           }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
