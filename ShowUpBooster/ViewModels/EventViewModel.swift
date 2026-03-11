//
//  EventViewModel.swift
//  ShowUpBooster
//
//  ViewModel for event confirmation and reminder management
//

import Foundation
import UserNotifications
import Combine
import UIKit

@MainActor
class EventViewModel: ObservableObject {
    @Published var event: Event
    @Published var isConfirmed: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var attendanceStatus: AttendanceStatus = .pending
    
    private let notificationManager = NotificationManager.shared
    
    enum AttendanceStatus {
        case pending
        case confirmed
        case declined
        case late
    }
    
    init(event: Event) {
        self.event = event
    }
    
    // MARK: - Confirmation
    
    func confirmAttendance() async {
        guard event.isUpcoming else {
            errorMessage = "This event has already passed"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        print("✅ User confirming attendance for: \(event.title)")
        
        // Request notification permission if needed
        if !notificationManager.hasPermission {
            let granted = await notificationManager.requestPermission()
            
            if !granted {
                print("⚠️ User declined notification permission")
                // Still mark as confirmed, but no reminders
            }
        }
        
        // Schedule reminders if we have permission
        if notificationManager.hasPermission {
            do {
                try await notificationManager.scheduleReminders(for: event)
            } catch {
                print("❌ Failed to schedule reminders: \(error)")
                errorMessage = "Couldn't schedule reminders, but you're confirmed!"
            }
        }
        
        // Mark as confirmed
        isConfirmed = true
        attendanceStatus = .confirmed
        
        // Notify landlord (async, doesn't block UI)
        Task {
            await notifyLandlord()
        }
        
        isLoading = false
        
        print("🎉 Attendance confirmed successfully")
    }
    
    // MARK: - Landlord Notification
    
    private func notifyLandlord() async {
        let resendAPIKey = "re_UqtXCbNP_KJc9zLe2pvyvpj14U6pwLtRv"
        
        print("📧 [ShowUpBooster] Starting email notification process...")
        
        // Get host email from event
        guard let hostEmail = event.hostEmail, !hostEmail.isEmpty else {
            print("⚠️ [ShowUpBooster] No host email available. Skipping notification.")
            return
        }
        
        print("📧 [ShowUpBooster] Recipient email: \(hostEmail)")
        
        // Validate email format (basic check)
        guard hostEmail.contains("@") && hostEmail.contains(".") else {
            print("⚠️ [ShowUpBooster] Invalid host email format: \(hostEmail)")
            return
        }
        
        guard let url = URL(string: "https://api.resend.com/emails") else {
            print("❌ [ShowUpBooster] Invalid Resend API URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(resendAPIKey)", forHTTPHeaderField: "Authorization")
        
        // Format the event time nicely
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let formattedDateTime = formatter.string(from: event.dateTime)
        
        let emailSubject = "✅ Showing Confirmed: \(event.title)"
        print("📧 [ShowUpBooster] Email subject: \(emailSubject)")
        
        // Create email payload
        let emailPayload: [String: Any] = [
            "from": "Event Reminder <notifications@northpoleapps.online>",  // Using your domain
            "to": [hostEmail],
            "subject": emailSubject,
            "html": """
                <h2>Great news! Someone just confirmed attendance! 🎉</h2>
                <p><strong>🏠 Property:</strong> \(event.title)</p>
                <p><strong>📍 Address:</strong> \(event.address)</p>
                <p><strong>⏰ Showing Time:</strong> \(formattedDateTime)</p>
                <p><strong>✅ Confirmed at:</strong> \(Date().formatted(date: .abbreviated, time: .shortened))</p>
                <hr>
                <p style="color: #666; font-size: 12px;">They'll receive automatic reminders 1 day before, 2 hours before, and 30 minutes before the showing.</p>
                """
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: emailPayload)
            
            // Log the payload
            if let payloadString = String(data: request.httpBody!, encoding: .utf8) {
                print("📧 [ShowUpBooster] Email payload: \(payloadString)")
            }
            
            print("📧 [ShowUpBooster] Sending email to Resend API...")
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                let responseBody = String(data: data, encoding: .utf8) ?? "No response body"
                print("📧 [ShowUpBooster] Resend API response status: \(httpResponse.statusCode)")
                print("📧 [ShowUpBooster] Resend API response body: \(responseBody)")
                
                if (200...299).contains(httpResponse.statusCode) {
                    print("✅ [ShowUpBooster] Landlord notified via email successfully")
                } else {
                    print("⚠️ [ShowUpBooster] Email notification failed with status \(httpResponse.statusCode)")
                }
            }
        } catch {
            print("⚠️ [ShowUpBooster] Failed to send landlord notification: \(error.localizedDescription)")
            // Don't show error to user - confirmation still works locally
        }
    }
    
    // MARK: - Status Updates
   
    func markAsRunningLate() {
        attendanceStatus = .late
        print("⏰ User marked as running late")
        
        // Open Messages app with pre-filled message to host
        openMessageToHost()
    }
    
    func openMessageToHost() {
        guard let hostContact = event.hostContact else {
            print("⚠️ No host contact available")
            return
        }
        
        // Generate pre-filled message
        let message = generateRunningLateMessage()
        
        // Clean phone number (remove spaces, dashes, parentheses)
        let cleanedContact = hostContact.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        // Create SMS URL with pre-filled body
        let encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? message
        let smsURLString = "sms:\(cleanedContact)&body=\(encodedMessage)"
        
        if let smsURL = URL(string: smsURLString), UIApplication.shared.canOpenURL(smsURL) {
            UIApplication.shared.open(smsURL)
            print("✅ Opened Messages app with pre-filled message")
        } else {
            print("❌ Failed to open Messages app")
        }
    }
    
    func generateRunningLateMessage() -> String {
        let hostName = event.hostName ?? "there"
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let eventTime = formatter.string(from: event.dateTime)
        
        return "Hi \(hostName), I'm running late for the \(event.title) at \(eventTime). I'll be there as soon as I can!"
    }
    
    func cancelAttendance() {
        attendanceStatus = .declined
        
        // Cancel scheduled notifications
        notificationManager.cancelReminders(for: event)
        
        print("❌ User cancelled attendance")
        
        // Open Messages app with pre-filled cancellation message
        openCancellationMessageToHost()
    }
    
    func openCancellationMessageToHost() {
        guard let hostContact = event.hostContact else {
            print("⚠️ No host contact available")
            return
        }
        
        // Generate pre-filled cancellation message
        let message = generateCancellationMessage()
        
        // Clean phone number (remove spaces, dashes, parentheses)
        let cleanedContact = hostContact.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        // Create SMS URL with pre-filled body
        let encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? message
        let smsURLString = "sms:\(cleanedContact)&body=\(encodedMessage)"
        
        if let smsURL = URL(string: smsURLString), UIApplication.shared.canOpenURL(smsURL) {
            UIApplication.shared.open(smsURL)
            print("✅ Opened Messages app with pre-filled cancellation message")
        } else {
            print("❌ Failed to open Messages app")
        }
    }
    
    func generateCancellationMessage() -> String {
        let hostName = event.hostName ?? "there"
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        let eventTime = formatter.string(from: event.dateTime)
        
        return "Hi \(hostName), I'm sorry but I won't be able to make it to the \(event.title) on \(eventTime). Apologies for the inconvenience."
    }
    
    // MARK: - Helper Methods
    
    var canConfirm: Bool {
        event.isUpcoming && !isConfirmed
    }
    
    var confirmButtonText: String {
        if isLoading {
            return "Confirming..."
        } else if isConfirmed {
            return "You're All Set!"
        } else {
            return "Confirm & Remind Me"
        }
    }
    
    var statusMessage: String {
        switch attendanceStatus {
        case .pending:
            return "Tap to confirm your attendance"
        case .confirmed:
            return "You're confirmed! We'll remind you."
        case .declined:
            return "Message opened to notify host"
        case .late:
            return "Message opened to notify host"
        }
    }
    
    var statusIcon: String {
        switch attendanceStatus {
        case .pending:
            return "clock.fill"
        case .confirmed:
            return "checkmark.circle.fill"
        case .declined:
            return "xmark.circle.fill"
        case .late:
            return "clock.arrow.circlepath"
        }
    }
    
    var statusColor: String {
        switch attendanceStatus {
        case .pending:
            return "orange"
        case .confirmed:
            return "green"
        case .declined:
            return "red"
        case .late:
            return "yellow"
        }
    }
}
