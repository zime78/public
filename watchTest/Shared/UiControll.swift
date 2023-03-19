//
//  UiControll.swift
//  watchTest
//
//  Created by zimeVX on 2023/03/19.
//

import Foundation

#if os(iOS)
import UIKit
#endif

@objc
class UiControll: NSObject {
    
    //테스트용 (컴파일 오류 막는예)
//#if os(iOS)
    func onTestView() -> UIView{
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
//#endif
    
    
    
}
    
    
    
