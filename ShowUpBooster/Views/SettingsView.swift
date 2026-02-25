//
//  SettingsView.swift
//  ShowUpBooster
//
//  Settings and information view for ShowUpBooster
//

import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        NavigationStack {
            Form {
                Section("How It Works") {
                    VStack(alignment: .leading, spacing: 16) {
                        InfoRow(
                            icon: "1.circle.fill",
                            title: "Create Event",
                            description: "Fill in event details and generate an invitation link"
                        )
                        
                        InfoRow(
                            icon: "2.circle.fill",
                            title: "Share Link",
                            description: "Send the link via Messages, Email, or any app"
                        )
                        
                        InfoRow(
                            icon: "3.circle.fill",
                            title: "Recipients Confirm",
                            description: "They tap the link and confirm attendance instantly"
                        )
                        
                        InfoRow(
                            icon: "4.circle.fill",
                            title: "Smart Reminders",
                            description: "They get automatic reminders before the event"
                        )
                    }
                    .padding(.vertical, 8)
                }
                
                Section("About ShowUpBooster") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                            .foregroundColor(.secondary)
                    }
                    
                    Link(destination: URL(string: "https://imentos.github.io/ShowUpBooster/privacy.html")!) {
                        HStack {
                            Text("Privacy Policy")
                            Spacer()
                            Image(systemName: "arrow.up.forward.square")
                                .font(.caption)
                        }
                    }
                    
                    Link(destination: URL(string: "https://imentos.github.io/ShowUpBooster/support.html")!) {
                        HStack {
                            Text("Support & FAQ")
                            Spacer()
                            Image(systemName: "arrow.up.forward.square")
                                .font(.caption)
                        }
                    }
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("App Clips Technology")
                            .font(.headline)
                        
                        Text("ShowUpBooster uses Apple's App Clips to let recipients confirm attendance without downloading the full app. They get instant access with smart reminders that work even after closing the clip.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

// MARK: - Info Row

struct InfoRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.purple)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview {
    SettingsView()
}
