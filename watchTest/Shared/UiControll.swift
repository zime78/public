//
//  UiControll.swift
//  watchTest
//
//  Created by zimeVX on 2023/03/19.
//

import Foundation
import UIKit

@objc
class UiControll: NSObject {
    
    //테스트용
#if os(iOS)
    func onTestView() -> UIView{
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
#endif
    
}
    
    
    
