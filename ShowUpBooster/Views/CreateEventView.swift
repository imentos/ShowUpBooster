//
//  CreateEventView.swift
//  ShowUpBooster
//
//  Event creation form for hosts to generate invitation links
//

import SwiftUI
import MapKit

struct CreateEventView: View {
    @AppStorage("savedEvents") private var savedEventsData: Data = Data()
    
    @State private var eventTitle = ""
    @State private var eventAddress = ""
    @State private var eventDateTime = Date().addingTimeInterval(86400) // Tomorrow
    @State private var hostName = ""
    @State private var hostContact = ""
    
    @State private var showingShareSheet = false
    @State private var generatedURL: URL?
    @State private var isGeneratingLink = false
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Event Details") {
                    TextField("Event Title", text: $eventTitle)
                        .autocorrectionDisabled()
                    
                    TextField("Event Address", text: $eventAddress)
                        .autocorrectionDisabled()
                    
                    DatePicker("Date & Time", selection: $eventDateTime, in: Date()...)
                }
                
                Section("Host Information") {
                    TextField("Host Name", text: $hostName)
                        .autocorrectionDisabled()
                    
                    TextField("Phone Number", text: $hostContact)
                        .keyboardType(.phonePad)
                    
                    if !hostContact.isEmpty && !isValidPhoneNumber(hostContact) {
                        Text("Please enter a valid phone number")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                
                Section {
                    Button(action: generateLink) {
                        HStack {
                            if isGeneratingLink {
                                ProgressView()
                                    .padding(.trailing, 8)
                                Text("Generating...")
                            } else {
                                Image(systemName: "link")
                                Text("Generate Invitation Link")
                            }
                            Spacer()
                        }
                    }
                    .disabled(!isFormValid || isGeneratingLink)
                    
                    if let url = generatedURL {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(url.absoluteString)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(nil)
                                .textSelection(.enabled)
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("Create Event Invitation")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingShareSheet) {
                if let url = generatedURL {
                    ShareSheet(items: [url])
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private var isFormValid: Bool {
        !eventTitle.isEmpty && 
        !eventAddress.isEmpty &&
        !hostName.isEmpty &&
        !hostContact.isEmpty &&
        isValidPhoneNumber(hostContact)
    }
    
    private func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        // Remove all non-numeric characters except +
        let cleanedNumber = phoneNumber.components(separatedBy: CharacterSet(charactersIn: "0123456789+").inverted).joined()
        
        // Must have at least 7 digits (min valid phone number length)
        // and no more than 15 digits (max international format)
        let digitCount = cleanedNumber.filter { $0.isNumber }.count
        return digitCount >= 7 && digitCount <= 15
    }
    
    private func generateLink() {
        isGeneratingLink = true
        
        // Geocode the address to get coordinates
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = eventAddress
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            isGeneratingLink = false
            
            guard let response = response,
                  let firstResult = response.mapItems.first else {
                errorMessage = "Could not find location for the address. Please check the address and try again."
                showingError = true
                print("❌ Location search failed: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let coordinate = firstResult.placemark.coordinate
            print("✅ Found coordinates: \(coordinate.latitude), \(coordinate.longitude)")
            
            // Create event with coordinates
            let event = Event(
                title: eventTitle,
                address: eventAddress,
                dateTime: eventDateTime,
                hostName: hostName,
                hostContact: hostContact,
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
            
            generatedURL = event.generateInvitationURL()
            print("✅ Generated URL: \(generatedURL?.absoluteString ?? "nil")")
        
            // Save to history
            if let url = generatedURL {
                saveEventToHistory(event: event, url: url)
                // Automatically trigger share sheet
                showingShareSheet = true
            }
        }
    }
    
    private func saveEventToHistory(event: Event, url: URL) {
        // Load existing events
        var savedEvents: [SavedEvent] = []
        if let decoded = try? JSONDecoder().decode([SavedEvent].self, from: savedEventsData) {
            savedEvents = decoded
        }
        
        // Add new event
        let savedEvent = SavedEvent(
            id: event.id,
            title: event.title,
            address: event.address,
            dateTime: event.dateTime,
            invitationURL: url.absoluteString,
            createdAt: Date()
        )
        savedEvents.append(savedEvent)
        
        // Save back
        if let encoded = try? JSONEncoder().encode(savedEvents) {
            savedEventsData = encoded
            print("✅ Saved event to history")
        }
    }
}

#Preview {
    CreateEventView()
}
