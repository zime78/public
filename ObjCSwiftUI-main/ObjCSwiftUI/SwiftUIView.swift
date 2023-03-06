//
//  SwiftUIView.swift
//  ObjCSwiftUI
//
//  Created by Corey Davis on 1/16/21.
//

import SwiftUI

struct SwiftUIView: View {
    var dismiss: () -> Void = {}

    var body: some View {
        VStack(spacing: 8) {
            Text("SwiftUI View 🎉")
                .font(.title)
                .bold()
            Button(action: {
                dismiss()
            }, label: {
                Text("Close")
            })
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
