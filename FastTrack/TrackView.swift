//
//  TrackView.swift
//  FastTrack
//
//  Created by user on 2023/12/5.
//

import SwiftUI
import AVKit

struct TrackView: View {
    let track: Track
    
    static private var audioPlayer: AVPlayer?
    @State private var isHovering = false
    
    var body: some View {
        Button {
            print("Play \(track.trackName)")
            play(track)
        } label: {
            ZStack(alignment: .bottom) {
                AsyncImage(url: track.artworkURL) { phase in
                    switch phase {
                    case .success(let image): image.resizable()
                    case .failure(_): Image(systemName: "questionmark").symbolVariant(.circle).font(.largeTitle)
                    default: ProgressView()
                    }
                }
                .frame(width: 150, height: 150)
                .scaleEffect(isHovering ? 1.2 : 1.0)
                .clipped()
                
                
                VStack {
                    Text(track.trackName).font(.headline).lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                    Text(track.artistName).foregroundStyle(.secondary).lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                }.padding(5).frame(width: 150).background(.regularMaterial)
            }
        }
        .buttonStyle(.borderless)
        .border(.primary, width: isHovering ? 3: 0)
        .onHover { hovering in
            // If the view is not responding to hover action, please move your mouse out of the app and move in again to activate the mechanism
            print("hover \(hovering)")
            withAnimation {
                isHovering = hovering
            }
        }
    }
    
    func play(_ track: Track) {
        TrackView.audioPlayer?.pause()
        TrackView.audioPlayer = AVPlayer(url: track.previewUrl)
        TrackView.audioPlayer?.play()
    }
}
