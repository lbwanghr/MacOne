//
//  ContentView.swift
//  CowsAndBulls
//
//  Created by Haoran Wang on 2023/8/31.
//

import SwiftUI

struct ContentView: View {
    @State private var text: String = ""
    @State private var answer: String = ""
    @State private var logs: [String] = []
    @State private var isGameOver: Bool = false
    
    @AppStorage("maximumGausses") var maximumGausses = 100
    @AppStorage("answerLength") var answerLength = 4
    @AppStorage("enableHardMode") var enableHardMode = false
    @AppStorage("showGuessCount") var showGuessCount = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                TextField("Enter your number", text: $text).onSubmit(submitGauss)
                Button("Go", action: submitGauss)
            }.padding()
            List(logs.indices, id: \.self) { index in
                HStack {
                    Text(logs[index])
                    Spacer()
                    if !enableHardMode || index == 0 {
                        let result = result(for:logs[index])
                        Text(result).colorfulGuess(result: result)
                    }
                }
                
               
            }
            .listStyle(.sidebar)
//            .scrollContentBackground(.hidden).background(.green.gradient)
            if showGuessCount {
                Text("Gausses: \(logs.count)/\(maximumGausses)").padding()
            }

        }
        .frame(width: 250)
        .frame(minHeight: 150, maxHeight:.infinity)
        .onAppear(perform: startNewGame)
        .alert(logs.count == maximumGausses ? "You've exhausted all opportunities for \(answer)" : "You win!", isPresented: $isGameOver) {
            Button("OK", action: startNewGame)
        } message: {
            Text("Press OK to start a new game.")
        }
        .navigationTitle("Cows and Bulls")
        .touchBar {
            HStack {
                Text("\(logs.count) Guesses").touchBarItemPrincipal()
                Spacer(minLength: 200)
            }
        }
        .onChange(of: answerLength, startNewGame)

    }
    
    func submitGauss() {
        guard text.count == 4 && Set(text).count == 4 else { return }
        guard !logs.contains(text) else { return }
        let badCharacterSet = CharacterSet(charactersIn: "0123456789").inverted
        guard text.rangeOfCharacter(from: badCharacterSet) == nil else { return }
        
        logs.insert(text, at: 0)
        
        if result(for: text).contains("🐂4") || logs.count == maximumGausses {
            isGameOver = true
        }
        
        text = ""
    }
    
    func result(for guess: String) -> String {
        var (cows, bulls) = (0, 0)
        for c in answer {
            if guess.contains(c) {
                if answer.firstIndex(of: c) == guess.firstIndex(of: c) {
                    bulls += 1
                } else {
                    cows += 1
                }
            }
        }
        return "🐄\(cows)🐂\(bulls)"
    }
    
    func startNewGame() {
        guard answerLength >= 3 && answerLength <= 8 else { return }
        logs.removeAll()
        let pool = "0123456789"
        answer = String(pool.shuffled().prefix(4))
    }

}

struct ColorfulGuess: ViewModifier {
    let color: Color
    func body(content: Content) -> some View {
        content.foregroundColor(color)
    }
}

extension View {
    func colorfulGuess(result: String) -> some View {
        let (cows, bulls) = (Int(String(result[result.index(result.startIndex, offsetBy: 1)])), Int(String(result[result.index(result.startIndex, offsetBy: 3)])))

        let sum = cows! + bulls!
        var color = Color.black
        switch sum {
        case 0: color = .red
        case 1...3: color = .yellow
        default: color = .green
        }
        return modifier(ColorfulGuess(color: color))
    }
}
