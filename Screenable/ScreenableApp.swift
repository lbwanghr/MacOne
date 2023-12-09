//
//  ScreenableApp.swift
//  Screenable
//
//  Created by user on 2023/11/14.
//

import SwiftUI

@main
struct ScreenableApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: ScreenableDocument()) { file in
            ContentView(document: file.$document)
        }
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(after: .saveItem) {
                Button("Export...") {
                    NSApp.sendAction(#selector(AppCommands.export), to: nil, from: nil)
                }
                .keyboardShortcut("e")
            }
        }
        
    }
    
    init() {
        let dict = [
            "FontSize": 12,
            "ShadowStrength": 1
        ]
        UserDefaults.standard.register(defaults: dict)
    }
}

@objc protocol AppCommands {
    func export()
}
