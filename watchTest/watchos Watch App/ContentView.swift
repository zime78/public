//
//  ContentView.swift
//  watchos Watch App
//
//  Created by zimeVX on 2023/03/09.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            
            Text("3")
            
            HStack {
                Button(action: {
                        ExpansionObj.testLog("test log1")
                      }, label: {
                          Text("data send")
                      })

                Button(action: {
                        //phone와watch 같이 사용하는 함수 이용해서 메시지 전달함
                        MessageManager.shared.onTestMessage(msg: "watch test message")
                      }, label: {
                          Text("message send")
                      })
            }
            
            
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
