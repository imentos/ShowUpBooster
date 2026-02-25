//
//  EventDetailView.swift
//  ShowUpBooster
//
//  Main view for event confirmation
//

import SwiftUI
import MapKit
import UserNotifications

struct EventDetailView: View {
    @StateObject var viewModel: EventViewModel
    @State private var showingConfirmation = false
    @Environment(\.openURL) private var openURL
    
    // Debug mode
    @State private var tapCount = 0
    @State private var debugModeEnabled = false
    @State private var lastTapTime = Date()
    @State private var showDebugAlert = false
    @State private var debugAlertMessage = ""
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 20) {
                    // Header with Icon
                    VStack(spacing: 12) {
                        Image(systemName: "calendar")
                            .font(.system(size: 80))
                            .foregroundColor(debugModeEnabled ? .green : .blue)
                            .onTapGesture {
                                handleDebugTap()
                            }
                        
                        Text(viewModel.event.title)
                            .font(.title2.bold())
                            .multilineTextAlignment(.center)
                        
                        // Debug mode indicator
                        if debugModeEnabled {
                            Text("🐛 Debug Mode")
                                .font(.caption2.bold())
                                .foregroundColor(.green)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.green.opacity(0.15))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.top, 40)
                    .padding(.horizontal)
                    
                    // Time Until Event Badge
                    if viewModel.event.isUpcoming {
                        Text(viewModel.event.timeUntilEvent)
                            .font(.subheadline.bold())
                            .foregroundColor(.orange)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(16)
                    }
                    
                    // Event Details Card
                    VStack(spacing: 16) {
                        // Date & Time
                        DetailRow(
                            icon: "calendar",
                            title: "When",
                            value: viewModel.event.formattedDateTime,
                            color: .blue
                        )
                        
                        Divider()
                        
                        // Location with Map
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.body)
                                    .foregroundColor(.red)
                                    .frame(width: 32, alignment: .leading)
                                
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("ADDRESS")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                        .textCase(.uppercase)
                                    
                                    Text(viewModel.event.address)
                                        .font(.callout)
                                        .fontWeight(.medium)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .textSelection(.enabled)
                                }
                                
                                Spacer()
                            }
                            
                            // Map Preview
                            Button(action: {
                                if let url = mapsURL(address: viewModel.event.address, 
                                                    latitude: viewModel.event.latitude, 
                                                    longitude: viewModel.event.longitude) {
                                    openURL(url)
                                }
                            }) {
                                MapPreview(
                                    address: viewModel.event.address,
                                    latitude: viewModel.event.latitude,
                                    longitude: viewModel.event.longitude
                                )
                                    .frame(minHeight: 150, idealHeight: 180, maxHeight: 220)
                                    .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                        }
                        
                        // Host Info
                        if let hostName = viewModel.event.hostName {
                            Divider()
                            DetailRow(
                                icon: "person.circle.fill",
                                title: "Host",
                                value: hostName,
                                subtitle: viewModel.event.hostContact,
                                color: .green
                            )
                        }
                        
                        // Additional Notes
                        if let notes = viewModel.event.additionalNotes {
                            Divider()
                            DetailRow(
                                icon: "note.text",
                                title: "Notes",
                                value: notes,
                                color: .purple
                            )
                        }
                    }
                    .padding(20)
                    .background(Color.secondary.opacity(0.05))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // Confirmation Status (if confirmed)
                    if viewModel.isConfirmed {
                        ConfirmationView()
                            .padding(.top, 8)
                    }
                    
                    // Error Message
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.caption2)
                            .foregroundColor(.red)
                            .padding(10)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.horizontal)
                    }
                }
                .padding(.bottom, 24)
            }
            
            // Bottom Button Section (OneTapHabit style)
            if !viewModel.isConfirmed {
                VStack(spacing: 10) {
                    // Permission Hint
                    HStack(spacing: 6) {
                        Image(systemName: "bell.fill")
                            .font(.caption2)
                        Text("We'll send you reminders before the event")
                            .font(.caption2)
                    }
                    .foregroundColor(.secondary)
                    
                    // Primary Action Button (OneTapHabit style)
                    Button(action: {
                        Task {
                            await viewModel.confirmAttendance()
                            if viewModel.isConfirmed {
                                showingConfirmation = true
                            }
                        }
                    }) {
                        HStack(spacing: 12) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title2)
                            }
                            
                            Text(viewModel.confirmButtonText)
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.blue)
                        )
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .disabled(viewModel.isLoading || !viewModel.canConfirm)
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
                .background(Color(uiColor: .systemBackground))
            } else {
                // Secondary Actions (when confirmed)
                HStack(spacing: 12) {
                    Button(action: {
                        viewModel.markAsRunningLate()
                    }) {
                        Label("Running Late", systemImage: "clock.arrow.circlepath")
                            .font(.subheadline)
                    }
                    .buttonStyle(.bordered)
                    
                    Button(action: {
                        viewModel.cancelAttendance()
                    }) {
                        Label("Can't Make It", systemImage: "xmark.circle")
                            .font(.subheadline)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                }
                .padding(.horizontal)
                .padding(.vertical, 16)
                .background(Color(uiColor: .systemBackground))
            }
            
            // Debug Actions
            if debugModeEnabled {
                VStack(spacing: 8) {
                    Text("Debug Tools")
                        .font(.caption2.bold())
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        testNotification()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "bell.badge.fill")
                            Text("Test Notification (10s)")
                                .font(.caption)
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.green)
                        )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(Color.green.opacity(0.05))
            }
        }
        .sheet(isPresented: $showingConfirmation) {
            ConfirmationSuccessView()
                .presentationDetents([.height(400), .medium])
        }
        .alert("Debug Notification", isPresented: $showDebugAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(debugAlertMessage)
        }
    }
    
    // MARK: - Helper Methods
    
    private func mapsURL(address: String, latitude: Double?, longitude: Double?) -> URL? {
        if let lat = latitude, let lng = longitude {
            // Use coordinates if available
            return URL(string: "http://maps.apple.com/?q=\(lat),\(lng)")
        } else {
            // Fall back to address
            let query = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return URL(string: "http://maps.apple.com/?q=\(query)")
        }
    }
    
    private func handleDebugTap() {
        let now = Date()
        
        // Reset tap count if more than 2 seconds since last tap
        if now.timeIntervalSince(lastTapTime) > 2.0 {
            tapCount = 0
        }
        
        lastTapTime = now
        tapCount += 1
        
        print("🔨 Debug tap count: \(tapCount)")
        
        if tapCount >= 5 {
            debugModeEnabled.toggle()
            tapCount = 0
            print(debugModeEnabled ? "✅ Debug mode enabled" : "❌ Debug mode disabled")
        }
    }
    
    private func testNotification() {
        print("🔔 Checking notification permission and scheduling test notification")
        
        // First check permission status
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                guard settings.authorizationStatus == .authorized else {
                    debugAlertMessage = "❌ Notification permission not granted.\n\nPlease confirm attendance first to grant permission, then try again."
                    showDebugAlert = true
                    print("❌ Notification permission denied: \(settings.authorizationStatus.rawValue)")
                    return
                }
                
                // Schedule test notification with real format
                let content = UNMutableNotificationContent()
                content.title = "Soon: \(viewModel.event.title)"
                content.body = "Heads up! Your event starts in 30 minutes at \(viewModel.event.address)"
                content.sound = .default
                content.categoryIdentifier = "EVENT_REMINDER"
                
                // Build event URL for re-invoking App Clip
                var components = URLComponents()
                components.scheme = "https"
                components.host = "imentos.github.io"
                components.path = "/ShowUpBooster/event"
                components.queryItems = viewModel.event.toURLParameters()
                
                content.userInfo = [
                    "eventId": viewModel.event.id.uuidString,
                    "eventTitle": viewModel.event.title,
                    "eventLocation": viewModel.event.address,
                    "eventURL": components.url?.absoluteString ?? "",
                    "reminderType": "test"
                ]
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
                let request = UNNotificationRequest(
                    identifier: "debug-test-\(UUID().uuidString)",
                    content: content,
                    trigger: trigger
                )
                
                UNUserNotificationCenter.current().add(request) { error in
                    DispatchQueue.main.async {
                        if let error = error {
                            debugAlertMessage = "❌ Failed to schedule notification:\n\(error.localizedDescription)"
                            showDebugAlert = true
                            print("❌ Failed to schedule test notification: \(error)")
                        } else {
                            debugAlertMessage = "✅ Test notification scheduled!\n\nYou should receive a notification in 10 seconds.\n\nMake sure the app is in background or screen is locked."
                            showDebugAlert = true
                            print("✅ Test notification scheduled successfully")
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Map Preview Component

struct MapPreview: View {
    let address: String
    let latitude: Double?
    let longitude: Double?
    
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    var body: some View {
        Map(coordinateRegion: .constant(region), annotationItems: [MapLocation(coordinate: region.center)]) { location in
            MapMarker(coordinate: location.coordinate, tint: .red)
        }
        .disabled(true)
        .overlay(
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Label("Open in Maps", systemImage: "arrow.up.right")
                        .font(.caption)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .cornerRadius(8)
                        .padding(8)
                }
            }
        )
        .task {
            if let lat = latitude, let lng = longitude {
                // Use provided coordinates
                region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: lat, longitude: lng),
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            } else {
                // Geocode address
                await geocodeAddress()
            }
        }
    }
    
    private func geocodeAddress() async {
        let geocoder = CLGeocoder()
        do {
            if let placemark = try await geocoder.geocodeAddressString(address).first,
               let location = placemark.location {
                await MainActor.run {
                    region = MKCoordinateRegion(
                        center: location.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                }
            }
        } catch {
            print("Geocoding failed: \(error)")
        }
    }
}

struct MapLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

// MARK: - Detail Row Component

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    var subtitle: String? = nil
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(color)
                .frame(width: 32, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                
                Text(value)
                    .font(.subheadline)
                    .fixedSize(horizontal: false, vertical: true)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    EventDetailView(viewModel: EventViewModel(event: .sample))
}
