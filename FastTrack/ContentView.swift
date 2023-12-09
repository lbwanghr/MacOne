//
//  ContentView.swift
//  FastTrack
//
//  Created by user on 2023/12/4.
//

import SwiftUI

struct ContentView: View {
    let gridItems: [GridItem] = [
        GridItem(.adaptive(minimum: 150, maximum: 200)),
    ]
    
    @AppStorage("searchText") var searchText = ""
    
    @State private var history = [String]()
    @State private var currentText: String?
    
    @State private var tracks = [Track]()
    @State private var searchState = SearchState.none
    
    var body: some View {
        NavigationSplitView {
            List(history, id: \.self, selection: $currentText) { item in
                Text("\(item)")
            }
            .frame(minWidth: 160)
            
        } detail: {
            switch searchState {
            case .none:
                Text("Enter a search term to begin.").frame(maxHeight: .infinity)
            case .searching:
                ProgressView().frame(maxHeight: .infinity)
            case .success:
                ScrollView {
                    LazyVGrid(columns: gridItems) {
                        ForEach(tracks, content: TrackView.init)
                    }
                    .padding()
                }
            case .error:
                Text("Sorry, your search failed - please check your internet connection then try again.").frame(maxHeight: .infinity)
            }
        }
        .searchable(text: $searchText, placement: .sidebar)
        .onSubmit(of: .search, submit)
        .onDeleteCommand {
            for _ in history {
                guard let currentText, let index = history.firstIndex(of: currentText) else { return }
                history.remove(at: index)
            }
        }
        .onChange(of: currentText) {
            guard let currentText else { return }
            startSearch(currentText)
        }

    }
    
    func performSearch(_ text: String) async throws {
        guard let text = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(text)&limit=100&entity=song") else { return }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
        
        tracks = searchResult.results
        
    }
    
    func startSearch(_ text: String) {
        searchState = .searching
        Task {
            do {
                try await performSearch(text)
                searchState = .success
            } catch {
                searchState = .error
            }
            
        }
    }
    
    func submit() {
        guard !searchText.isEmpty else { return }
        if !history.contains(searchText) {
            history.append(searchText)
        }
        currentText = searchText
        searchText = ""
        
        startSearch(currentText!)
    }
}

enum SearchState {
    case none, searching, success, error
}
