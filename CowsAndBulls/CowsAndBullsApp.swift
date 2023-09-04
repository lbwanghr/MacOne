import SwiftUI
@main
struct CowsAndBullsApp: App {
    var body: some Scene {
        Window("Cows and Bulls", id: "main") {
            ContentView()
        }.windowResizability(.contentSize)
        Settings(content: SettingsView.init)
    }
}

struct SettingsView: View {
    @AppStorage("maximumGausses") var maximumGausses = 100
    @AppStorage("answerLength") var answerLength = 4
    @AppStorage("enableHardMode") var enableHardMode = false
    @AppStorage("showGuessCount") var showGuessCount = false
    var body: some View {
        TabView {
            Form {
                TextField("Maximum Gausses", value: $maximumGausses, format: .number)
                    .help("The maximum number of answers you can submit. Changing this will immediately restart your game.")
                TextField("Answer Length", value: $answerLength, format: .number)
                    .help("The length of the number string to guess. Changing this will immediately restart your game.")
                if answerLength < 3 || answerLength > 8 {
                    Text("Must between 3 and 8").foregroundStyle(.red)
                }
            }
            .padding()
            .tabItem { Label("Game", systemImage: "number.circle") }
            Form {
                Toggle("Enable Hard Mode", isOn: $enableHardMode)
                    .help("This shows the cows and bulls score for only the most recent guess.")
                Toggle("Show Guess Count", isOn: $showGuessCount)
                    .help("Adds a footer below your guesses showing the total.")
            }
            .padding()
            .tabItem{ Label("Advanced", systemImage: "gearshape.2") }
            
        }.frame(width: 400)
        
    }
}
