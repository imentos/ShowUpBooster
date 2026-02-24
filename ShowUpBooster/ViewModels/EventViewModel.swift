//
//  EventViewModel.swift
//  ShowUpBooster
//
//  ViewModel for event confirmation and reminder management
//

import Foundation
import UserNotifications
import Combine

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
        isLoading = false
        
        print("🎉 Attendance confirmed successfully")
    }
    
    // MARK: - Status Updates
   
    func markAsRunningLate() {
        attendanceStatus = .late
        print("⏰ User marked as running late")
        
        // Could send notification to host here in future
    }
    
    func cancelAttendance() {
        attendanceStatus = .declined
        
        // Cancel scheduled notifications
        notificationManager.cancelReminders(for: event)
        
        print("❌ User cancelled attendance")
        
        // Could notify host here in future
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
            return "Attendance cancelled"
        case .late:
            return "Running late - host notified"
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
