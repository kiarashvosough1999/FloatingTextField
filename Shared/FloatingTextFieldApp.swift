//
//  FloatingTextFieldApp.swift
//  Shared
//
//  Created by Kiarash Vosough on 3/18/22.
//

import SwiftUI

@main
struct FloatingTextFieldApp: App {
    
    @State var text: String = ""
    
    var body: some Scene {
        WindowGroup {
            FloatingTextField(title: "Your Email Address", text: $text)
                .frame(width: 350, height: 60, alignment: .center)
        }
    }
}
