//
//  MacOneApp.swift
//  MacOne
//
//  Created by Haoran Wang on 2023/8/19.
//

import SwiftUI

@main
struct StormViewApp: App {
    var body: some Scene {
        Window("StormView", id: "main") {
            ContentView()
                .onAppear {
                    NSWindow.allowsAutomaticWindowTabbing = false
                }
        }
        .commands {
            CommandGroup(replacing: .newItem) { }
            CommandGroup(replacing: .undoRedo) { }
            CommandGroup(replacing: .pasteboard) { }
            CommandGroup(replacing: .help) { }
        }
    }
}
