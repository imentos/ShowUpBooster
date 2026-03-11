//
//  EventDetailView.swift
//  ShowUpBooster
//
//  Main view for event confirmation
//

import SwiftUI
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
    @State private var showLogViewer = false
    
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
                        HStack(alignment: .top, spacing: 8) {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("WHEN")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                    .textCase(.uppercase)
                                
                                Text(viewModel.event.formattedDateTime)
                                    .font(.callout)
                                    .fontWeight(.medium)
                            }
                            
                            Spacer()
                        }
                        
                        Divider()
                        
                        // Location
                        HStack(alignment: .top, spacing: 8) {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("ADDRESS")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                    .textCase(.uppercase)
                                
                                HStack(spacing: 6) {
                                    Text(viewModel.event.address)
                                        .font(.callout)
                                        .fontWeight(.medium)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    Button(action: {
                                        if let url = mapsURL(address: viewModel.event.address, 
                                                            latitude: viewModel.event.latitude, 
                                                            longitude: viewModel.event.longitude) {
                                            openURL(url)
                                        }
                                    }) {
                                        Image(systemName: "map.fill")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .padding(6)
                                            .background(Color.red)
                                            .clipShape(Circle())
                                    }
                                }
                            }
                            
                            Spacer()
                        }
                        
                        // Host Info
                        if let hostName = viewModel.event.hostName {
                            Divider()
                            HStack(alignment: .top, spacing: 8) {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("HOST")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                        .textCase(.uppercase)
                                    
                                    Text(hostName)
                                        .font(.subheadline)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    if let hostContact = viewModel.event.hostContact {
                                        HStack(spacing: 6) {
                                            Text(hostContact)
                                                .font(.callout)
                                                .fontWeight(.medium)
                                            
                                            // Phone and SMS buttons if contact looks like a phone number
                                            if isPhoneNumber(hostContact) {
                                                Button(action: {
                                                    callHost(hostContact)
                                                }) {
                                                    Image(systemName: "phone.fill")
                                                        .font(.caption)
                                                        .foregroundColor(.white)
                                                        .padding(6)
                                                        .background(Color.green)
                                                        .clipShape(Circle())
                                                }
                                                
                                                Button(action: {
                                                    messageHost(hostContact)
                                                }) {
                                                    Image(systemName: "message.fill")
                                                        .font(.caption)
                                                        .foregroundColor(.white)
                                                        .padding(6)
                                                        .background(Color.blue)
                                                        .clipShape(Circle())
                                                }
                                            }
                                        }
                                    }
                                    
                                    // Host Email
                                    if let hostEmail = viewModel.event.hostEmail {
                                        HStack(spacing: 6) {
                                            Text(hostEmail)
                                                .font(.callout)
                                                .fontWeight(.medium)
                                            
                                            Button(action: {
                                                emailHost(hostEmail)
                                            }) {
                                                Image(systemName: "envelope.fill")
                                                    .font(.caption)
                                                    .foregroundColor(.white)
                                                    .padding(6)
                                                    .background(Color.orange)
                                                    .clipShape(Circle())
                                            }
                                        }
                                    }
                                }
                                
                                Spacer()
                            }
                        }
                        
                        // Additional Notes
                        if let notes = viewModel.event.additionalNotes {
                            Divider()
                            HStack(alignment: .top, spacing: 8) {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("NOTES")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                        .textCase(.uppercase)
                                    
                                    Text(notes)
                                        .font(.callout)
                                        .fontWeight(.medium)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                
                                Spacer()
                            }
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: 500)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.blue.opacity(0.08))
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
                    )
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
                        Label("Message Host - Running Late", systemImage: "message.fill")
                            .font(.subheadline)
                    }
                    .buttonStyle(.bordered)
                    .disabled(viewModel.event.hostContact == nil)
                    
                    Button(action: {
                        viewModel.cancelAttendance()
                    }) {
                        Label("Message Host - Can't Make It", systemImage: "message.badge.fill")
                            .font(.subheadline)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    .disabled(viewModel.event.hostContact == nil)
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
                    
                    Button(action: {
                        showLogViewer = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "doc.text.magnifyingglass")
                            Text("View Debug Logs")
                                .font(.caption)
                            
                            Spacer()
                            
                            Text("\(LogManager.shared.getLogs().count)")
                                .font(.caption.monospacedDigit())
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(
                                    Capsule()
                                        .fill(.white.opacity(0.3))
                                )
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.blue)
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
        .sheet(isPresented: $showLogViewer) {
            LogViewerView()
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
    
    private func isPhoneNumber(_ contact: String) -> Bool {
        // Check if contact contains digits and common phone characters
        let phoneCharacterSet = CharacterSet(charactersIn: "0123456789+()-. ")
        let contactCharacterSet = CharacterSet(charactersIn: contact)
        
        // Must contain at least one digit and only valid phone characters
        let hasDigit = contact.rangeOfCharacter(from: .decimalDigits) != nil
        let onlyPhoneChars = phoneCharacterSet.isSuperset(of: contactCharacterSet)
        
        return hasDigit && onlyPhoneChars && contact.count >= 7
    }
    
    private func callHost(_ phoneNumber: String) {
        // Remove all non-numeric characters except +
        let cleanedNumber = phoneNumber.components(separatedBy: CharacterSet(charactersIn: "0123456789+").inverted).joined()
        
        if let url = URL(string: "tel:\(cleanedNumber)") {
            openURL(url)
        }
    }
    
    private func messageHost(_ phoneNumber: String) {
        // Remove all non-numeric characters except +
        let cleanedNumber = phoneNumber.components(separatedBy: CharacterSet(charactersIn: "0123456789+").inverted).joined()
        
        if let url = URL(string: "sms:\(cleanedNumber)") {
            openURL(url)
        }
    }
    
    private func emailHost(_ email: String) {
        if let url = URL(string: "mailto:\(email)") {
            openURL(url)
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
                components.path = "/ShowUpBooster/"
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

// MARK: - Detail Row Component

struct DetailRow: View {
    var icon: String? = nil
    let title: String
    let value: String
    var subtitle: String? = nil
    var color: Color? = nil
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if let icon = icon, let color = color {
                Image(systemName: icon)
                    .font(.body)
                    .foregroundColor(color)
            }
            
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
