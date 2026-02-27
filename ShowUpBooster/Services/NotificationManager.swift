//
//  NotificationManager.swift
//  ShowUpBooster
//
//  Manages notification permissions and reminder scheduling
//

import Foundation
import UserNotifications
import Combine

@MainActor
class NotificationManager: ObservableObject {
    @Published var permissionStatus: UNAuthorizationStatus = .notDetermined
    @Published var hasPermission: Bool = false
    
    static let shared = NotificationManager()
    
    private init() {
        Task {
            await checkPermissionStatus()
            await registerNotificationCategories()
        }
    }
    
    // MARK: - Category Registration
    
    func registerNotificationCategories() async {
        let center = UNUserNotificationCenter.current()
        
        // Create "View Event" action that opens the App Clip
        let viewAction = UNNotificationAction(
            identifier: "VIEW_EVENT",
            title: "View Event",
            options: [.foreground]
        )
        
        // Create category with actions
        let category = UNNotificationCategory(
            identifier: "EVENT_REMINDER",
            actions: [viewAction],
            intentIdentifiers: [],
            options: []
        )
        
        center.setNotificationCategories([category])
        print("📋 Registered notification categories")
    }
    
    // MARK: - Permission Management
    
    func checkPermissionStatus() async {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        permissionStatus = settings.authorizationStatus
        hasPermission = settings.authorizationStatus == .authorized
        
        print("📢 Notification Permission Status: \(permissionStatus.rawValue)")
    }
    
    func requestPermission() async -> Bool {
        let center = UNUserNotificationCenter.current()
        
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            
            await checkPermissionStatus()
            
            print(granted ? "✅ Notification permission granted" : "❌ Notification permission denied")
            return granted
        } catch {
            print("❌ Error requesting notification permission: \(error)")
            return false
        }
    }
    
    // MARK: - Reminder Scheduling
    
    func scheduleReminders(for event: Event) async throws {
        guard hasPermission else {
            print("❌ Cannot schedule reminders - no permission")
            throw NotificationError.permissionDenied
        }
        
        let center = UNUserNotificationCenter.current()
        
        // Remove any existing notifications for this event
        center.removePendingNotificationRequests(withIdentifiers: [
            notificationID(for: event, type: .dayBefore),
            notificationID(for: event, type: .twoHours),
            notificationID(for: event, type: .thirtyMinutes)
        ])
        
        let now = Date()
        var scheduledCount = 0
        
        // Schedule reminders at different intervals
        let reminders: [(interval: TimeInterval, type: ReminderType)] = [
            (86400, .dayBefore),      // 24 hours
            (7200, .twoHours),         // 2 hours
            (1800, .thirtyMinutes)     // 30 minutes
        ]
        
        for (interval, type) in reminders {
            let reminderTime = event.dateTime.addingTimeInterval(-interval)
            
            // Only schedule if the reminder time is in the future
            if reminderTime > now {
                try await scheduleNotification(
                    for: event,
                    at: reminderTime,
                    type: type
                )
                scheduledCount += 1
            }
        }
        
        print("✅ Scheduled \(scheduledCount) reminder(s) for: \(event.title)")
    }
    
    private func scheduleNotification(
        for event: Event,
        at date: Date,
        type: ReminderType
    ) async throws {
        let content = UNMutableNotificationContent()
        content.title = type.title(for: event)
        content.body = type.body(for: event)
        content.sound = .default
        content.categoryIdentifier = "EVENT_REMINDER"
        
        // Build event URL for re-invoking App Clip
        var components = URLComponents()
        components.scheme = "https"
        components.host = "imentos.github.io"
        components.path = "/ShowUpBooster/"
        components.queryItems = event.toURLParameters()
        
        content.userInfo = [
            "eventId": event.id.uuidString,
            "eventTitle": event.title,
            "eventLocation": event.address,
            "eventTime": ISO8601DateFormatter().string(from: event.dateTime),
            "eventURL": components.url?.absoluteString ?? ""
        ]
        
        // Create trigger
        let dateComponents = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: date
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // Create request
        let identifier = notificationID(for: event, type: type)
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        // Schedule
        try await UNUserNotificationCenter.current().add(request)
        
        print("📅 Scheduled \(type.rawValue) reminder for \(date.formatted(date: .abbreviated, time: .shortened))")
    }
    
    private func notificationID(for event: Event, type: ReminderType) -> String {
        return "showupbooster.\(event.id.uuidString).\(type.rawValue)"
    }
    
    // MARK: - Cancel Reminders
    
    func cancelReminders(for event: Event) {
        let center = UNUserNotificationCenter.current()
        let identifiers = [
            notificationID(for: event, type: .dayBefore),
            notificationID(for: event, type: .twoHours),
            notificationID(for: event, type: .thirtyMinutes)
        ]
        
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
        print("🗑️ Cancelled reminders for: \(event.title)")
    }
    
    func getPendingNotifications() async -> [UNNotificationRequest] {
        return await UNUserNotificationCenter.current().pendingNotificationRequests()
    }
}

// MARK: - Supporting Types

enum ReminderType: String {
    case dayBefore = "day-before"
    case twoHours = "2-hours"
    case thirtyMinutes = "30-minutes"
    
    func title(for event: Event) -> String {
        switch self {
        case .dayBefore:
            return "Tomorrow: \(event.title)"
        case .twoHours:
            return "In 2 Hours: \(event.title)"
        case .thirtyMinutes:
            return "Soon: \(event.title)"
        }
    }
    
    func body(for event: Event) -> String {
        switch self {
        case .dayBefore:
            return "Don't forget! Your event is tomorrow at \(event.formattedTime)"
        case .twoHours:
            return "Time to get ready! Your event starts at \(event.formattedTime) - \(event.address)"
        case .thirtyMinutes:
            return "Heads up! Your event starts in 30 minutes at \(event.address)"
        }
    }
}

enum NotificationError: LocalizedError {
    case permissionDenied
    case schedulingFailed
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Notification permission is required to set reminders"
        case .schedulingFailed:
            return "Failed to schedule reminders"
        }
    }
}
