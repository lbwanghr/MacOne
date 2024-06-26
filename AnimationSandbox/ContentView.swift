//
//  ContentView.swift
//  AnimationSandbox
//
//  Created by user on 2023/12/3.
//

import SwiftUI

struct ContentView: View {
    @State private var animationAmount = 0.0
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero
    @State private var isShowingRed = false
    let letters = Array("Hello SwiftUI")
    

    
    var body: some View {
        VStack {
            Button("Click Me") {
                withAnimation() {
                    isShowingRed.toggle()
                }
                
            }
            
            if isShowingRed {
                Rectangle().fill(.red).frame(width: 200, height: 200)
                    .transition(.pivot)
//                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
            }
            
            
        }
        .frame(width: 300, height: 300)
    }
    
    var snake: some View {
        HStack(spacing: 0) {
            ForEach(0..<letters.count, id: \.self) { num in
                Text(String(letters[num])).padding(5).font(.title)
                    .background(enabled ? .blue : .red)
                    .offset(dragAmount)
                    .animation(.default.delay(Double(num) / 20), value: dragAmount)
            }
        }
        .gesture(
            DragGesture()
                .onChanged { dragAmount = $0.translation }
                .onEnded { _ in
                    withAnimation(.spring()) {
                        dragAmount = .zero
                        enabled.toggle()
                    }
                }
        )
        .padding(200)
    }
}

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}
