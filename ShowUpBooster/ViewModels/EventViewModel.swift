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
        
        LogManager.shared.info("✅ User confirming attendance for: \(event.title)")
        
        // Request notification permission if needed
        if !notificationManager.hasPermission {
            let granted = await notificationManager.requestPermission()
            
            if !granted {
                LogManager.shared.warning("⚠️ User declined notification permission")
                // Still mark as confirmed, but no reminders
            }
        }
        
        // Schedule reminders if we have permission
        if notificationManager.hasPermission {
            do {
                try await notificationManager.scheduleReminders(for: event)
            } catch {
                LogManager.shared.error("❌ Failed to schedule reminders: \(error)")
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
        
        LogManager.shared.success("🎉 Attendance confirmed successfully")
    }
    
    // MARK: - Landlord Notification
    
    private func notifyLandlord() async {
        LogManager.shared.info("📧 Starting host notification process...")
        
        // Get host contact from event
        guard let hostContact = event.hostContact, !hostContact.isEmpty else {
            LogManager.shared.warning("⚠️ No host contact available. Skipping notification.")
            return
        }
        
        LogManager.shared.info("📧 Host contact: \(hostContact)")
        
        // Generate pre-filled confirmation message
        let message = generateConfirmationMessage()
        
        // Clean phone number (remove spaces, dashes, parentheses)
        let cleanedContact = hostContact.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        // Create SMS URL with pre-filled body
        let encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? message
        let smsURLString = "sms:\(cleanedContact)&body=\(encodedMessage)"
        
        if let smsURL = URL(string: smsURLString), UIApplication.shared.canOpenURL(smsURL) {
            await UIApplication.shared.open(smsURL)
            LogManager.shared.success("✅ Opened Messages app with confirmation notification")
        } else {
            LogManager.shared.error("❌ Failed to open Messages app")
        }
    }
    
    func generateConfirmationMessage() -> String {
        let hostName = event.hostName ?? "there"
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        let eventTime = formatter.string(from: event.dateTime)
        
        return "Hi \(hostName), I've confirmed my attendance for the showing at \(event.title) on \(eventTime). Looking forward to it!"
    }
    
    // MARK: - Status Updates
   
    func markAsRunningLate() {
        attendanceStatus = .late
        LogManager.shared.info("⏰ User marked as running late")
        
        // Open Messages app with pre-filled message to host
        openMessageToHost()
    }
    
    func openMessageToHost() {
        guard let hostContact = event.hostContact else {
            LogManager.shared.warning("⚠️ No host contact available")
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
            LogManager.shared.info("✅ Opened Messages app with pre-filled message")
        } else {
            LogManager.shared.error("❌ Failed to open Messages app")
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
        
        LogManager.shared.info("❌ User cancelled attendance")
        
        // Open Messages app with pre-filled cancellation message
        openCancellationMessageToHost()
    }
    
    func openCancellationMessageToHost() {
        guard let hostContact = event.hostContact else {
            LogManager.shared.warning("⚠️ No host contact available")
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
            LogManager.shared.info("✅ Opened Messages app with pre-filled cancellation message")
        } else {
            LogManager.shared.error("❌ Failed to open Messages app")
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
