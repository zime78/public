//
//  SwiftUIViewInterface.swift
//  ObjCSwiftUI
//
//  Created by Corey Davis on 1/16/21.
//

import Foundation
import SwiftUI

class SwiftUIViewFactory: NSObject {
    @objc static func makeSwiftUIView(dismissHandler: @escaping (() -> Void)) -> UIViewController {
        return UIHostingController(rootView: SwiftUIView(dismiss: dismissHandler))
    }
}
