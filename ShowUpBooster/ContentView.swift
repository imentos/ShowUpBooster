//
//  ContentView.swift
//  ShowUpBooster
//
//  Created by Kuo, Ray on 2/23/26.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var appState: AppState
    @State private var selectedTab = 0
    
    var body: some View {
        Group {
            if let event = appState.currentEvent {
                // Show event detail view when opened from invitation link
                NavigationView {
                    EventDetailView(viewModel: EventViewModel(event: event))
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Close") {
                                    appState.currentEvent = nil
                                }
                            }
                        }
                }
            } else {
                // Show normal tab view for full app features
                TabView(selection: $selectedTab) {
                    CreateEventView()
                        .tabItem {
                            Label("Create Event", systemImage: "plus.circle.fill")
                        }
                        .tag(0)
                    
                    EventHistoryView()
                        .tabItem {
                            Label("My Events", systemImage: "list.bullet")
                        }
                        .tag(1)
                    
                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gear")
                        }
                        .tag(2)
                }
                .tint(.purple)
            }
        }
    }
}

#Preview {
    ContentView(appState: AppState())
}
