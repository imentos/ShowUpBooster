//
//  ContentView.swift
//  ShowUpBooster
//
//  Created by Kuo, Ray on 2/23/26.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
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

#Preview {
    ContentView()
}
