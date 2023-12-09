//
//  AnimationSandboxApp.swift
//  AnimationSandbox
//
//  Created by user on 2023/12/3.
//

import SwiftUI

@main
struct AnimationSandboxApp: App {
    var body: some Scene {
        Window("AnimationSandbox", id: "main") {
            ContentView()
                .toolbar {
                    Button { } label: { Label("Play", systemImage: "play") }
                    Button { } label: { Label("Stop", systemImage: "stop") }
                }
        }
    }
}
