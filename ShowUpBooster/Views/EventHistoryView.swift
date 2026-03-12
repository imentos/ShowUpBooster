//
//  EventHistoryView.swift
//  ShowUpBooster
//
//  View showing previously created events and their invitation links
//

import SwiftUI

struct EventHistoryView: View {
    @AppStorage("savedEvents") private var savedEventsData: Data = Data()
    @State private var savedEvents: [SavedEvent] = []
    @State private var selectedEvent: SavedEvent?
    @State private var showingShareSheet = false
    
    var body: some View {
        NavigationStack {
            Group {
                if savedEvents.isEmpty {
                    emptyState
                } else {
                    eventsList
                }
            }
            .navigationTitle("My Events")
            .onAppear(perform: loadEvents)
            .sheet(isPresented: $showingShareSheet) {
                if let event = selectedEvent {
                    if let url = URL(string: event.invitationURL) {
                        ShareSheet(items: [url])
                    } else if let encodedURL = event.invitationURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                              let url = URL(string: encodedURL) {
                        ShareSheet(items: [url])
                    } else {
                        VStack(spacing: 20) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 50))
                                .foregroundColor(.orange)
                            Text("Unable to share event")
                                .font(.headline)
                            Text("Invalid URL: \(event.invitationURL)")
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .padding()
                            Button("Copy URL") {
                                UIPasteboard.general.string = event.invitationURL
                            }
                            .buttonStyle(.bordered)
                            Button("Close") {
                                showingShareSheet = false
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                    }
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.orange)
                        Text("No event selected")
                            .font(.headline)
                        Button("Close") {
                            showingShareSheet = false
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                }
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No Events Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Create your first event invitation\nto get started")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private var eventsList: some View {
        List {
            ForEach(savedEvents.sorted(by: { $0.createdAt > $1.createdAt })) { event in
                EventHistoryRow(event: event) {
                    print("🔍 Sharing event: \(event.title)")
                    print("🔍 URL string: \(event.invitationURL)")
                    print("🔍 URL string count: \(event.invitationURL.count)")
                    if let url = URL(string: event.invitationURL) {
                        print("✅ URL created successfully: \(url.absoluteString)")
                    } else {
                        print("❌ Failed to create URL from string")
                    }
                    selectedEvent = event
                    showingShareSheet = true
                }
            }
            .onDelete(perform: deleteEvents)
        }
    }
    
    private func loadEvents() {
        if let decoded = try? JSONDecoder().decode([SavedEvent].self, from: savedEventsData) {
            savedEvents = decoded
        }
    }
    
    private func deleteEvents(at offsets: IndexSet) {
        savedEvents.remove(atOffsets: offsets)
        saveEvents()
    }
    
    private func saveEvents() {
        if let encoded = try? JSONEncoder().encode(savedEvents) {
            savedEventsData = encoded
        }
    }
}

// MARK: - Saved Event Model

struct SavedEvent: Identifiable, Codable {
    let id: UUID
    let title: String
    let address: String
    let dateTime: Date
    let invitationURL: String
    let createdAt: Date
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: dateTime)
    }
    
    var isUpcoming: Bool {
        dateTime > Date()
    }
}

// MARK: - Event History Row

struct EventHistoryRow: View {
    let event: SavedEvent
    let onShare: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.title)
                        .font(.headline)
                    
                    Text(event.address)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Image(systemName: "calendar")
                        Text(event.formattedDate)
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    if !event.isUpcoming {
                        Text("Past")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                    
                    Button(action: onShare) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    EventHistoryView()
}
