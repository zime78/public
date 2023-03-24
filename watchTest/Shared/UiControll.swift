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
    
    //컴파일오류 해결방법
    //1. 더미파일을 이용하는 방법
    //2. target build define을 이용하여 해결하는 방법(폰 에서는 오류가 발생이 안됨)
//#if os(iOS)
    func onTestView() -> UIView {
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
//#endif
    
    
    
}
    
    
    
