//
//  ShowUpBoosterApp.swift
//  ShowUpBooster
//
//  Created by Kuo, Ray on 2/23/26.
//

import SwiftUI
import Combine

@main
struct ShowUpBoosterApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if let event = appState.currentEvent {
                    EventDetailView(viewModel: EventViewModel(event: event))
                } else {
                    // Fallback view if no URL parameters
                    PlaceholderView()
                }
            }
            .onOpenURL { url in
                handleIncomingURL(url)
            }
        }
    }
    
    private func handleIncomingURL(_ url: URL) {
        print("📱 ShowUpBooster received URL: \(url.absoluteString)")
        
        // Parse event from URL
        if let event = Event.fromURL(url) {
            print("✅ Successfully parsed event: \(event.title)")
            appState.currentEvent = event
        } else {
            print("❌ Failed to parse event from URL")
        }
    }
}

// MARK: - App State

@MainActor
class AppState: ObservableObject {
    @Published var currentEvent: Event? = nil
}

// MARK: - Placeholder View

struct PlaceholderView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar.badge.clock")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("ShowUpBooster")
                .font(.title.bold())
            
            Text("Scan an event QR code or open an event link to confirm your attendance")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding()
    }
}
