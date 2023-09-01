//
//  ContentView.swift
//  MacOne
//
//  Created by Haoran Wang on 2023/8/19.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedImage: Int?
    
    var body: some View {
        
        NavigationSplitView {
            List(0..<10, selection: $selectedImage) { index in
                Text("Storm\(index + 1)")
            }
        } detail: {
            if let selectedImage = selectedImage {
                Image("\(selectedImage)").resizable().scaledToFit()
            } else {
                Text("Please select an Image")
            }
        }.frame(minWidth: 480, minHeight: 320)
        
    }
}

#Preview {
    ContentView()
}
