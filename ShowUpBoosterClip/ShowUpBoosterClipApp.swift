//
//  ShowUpBoosterApp.swift
//  ShowUpBooster
//
//  Created by Kuo, Ray on 2/23/26.
//

import SwiftUI
import Combine
import UserNotifications
import os
import UIKit

private let logger = Logger(subsystem: "com.showupbooster.clip", category: "AppClip")

@main
struct ShowUpBoosterApp: App {
    @StateObject private var appState = AppState()
    
    init() {
        logger.info("🚀 ShowUpBooster App Clip is launching...")
        
        // Set notification delegate immediately in init
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
        logger.info("   🔔 Notification delegate set in init")
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if let event = appState.currentEvent {
                    EventDetailView(viewModel: EventViewModel(event: event))
                } else {
                    // Fallback view if no URL parameters
                    PlaceholderView()
                }
            }
            .onAppear {
                logger.info("👀 App appeared - starting initialization")
                
                // Connect delegate to appState
                logger.info("   🔗 Connecting notification delegate to app state")
                NotificationDelegate.shared.appState = appState
                
                // Register notification categories for actions
                Task {
                    await NotificationDelegate.shared.registerNotificationCategories()
                }
                
                // Process any pending event from notification tap during launch
                logger.info("   🔄 Processing pending events...")
                NotificationDelegate.shared.processPendingEvent()
                
                // Check if launched with URL
                logger.info("   🌐 Checking for launch URL...")
                if let urlString = ProcessInfo.processInfo.environment["_XCAppClipURL"] {
                    logger.info("   ✅ Found _XCAppClipURL: \(urlString)")
                    if let url = URL(string: urlString) {
                        handleIncomingURL(url)
                    }
                } else {
                    logger.info("   ℹ️ No _XCAppClipURL found in environment")
                }
            }
            .onOpenURL { url in
                logger.info("📨 onOpenURL triggered")
                handleIncomingURL(url)
            }
        }
    }
    
    private func handleIncomingURL(_ url: URL) {
        logger.info("📱 ShowUpBooster received URL: \(url.absoluteString)")
        
        // Parse event from URL
        if let event = Event.fromURL(url) {
            logger.notice("✅ Successfully parsed event: \(event.title)")
            appState.currentEvent = event
        } else {
            logger.error("❌ Failed to parse event from URL")
        }
    }
}

// MARK: - App State

@MainActor
class AppState: ObservableObject {
    @Published var currentEvent: Event? = nil
}

// MARK: - Placeholder View

struct PlaceholderView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar.badge.clock")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("ShowUpBooster")
                .font(.title.bold())
            
            Text("Scan an event QR code or open an event link to confirm your attendance")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding()
    }
}

// MARK: - Notification Delegate

@MainActor
class NotificationDelegate: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationDelegate()
    
    weak var appState: AppState?
    private var pendingEventURL: String?
    
    private override init() {
        super.init()
        logger.info("🔔 NotificationDelegate singleton created")
    }
    
    // MARK: - Category Registration
    
    func registerNotificationCategories() async {
        let center = UNUserNotificationCenter.current()
        
        // Create "View Event" action
        let viewAction = UNNotificationAction(
            identifier: "VIEW_EVENT",
            title: "View Event",
            options: [.foreground]
        )
        
        // Create category
        let category = UNNotificationCategory(
            identifier: "EVENT_REMINDER",
            actions: [viewAction],
            intentIdentifiers: [],
            options: []
        )
        
        center.setNotificationCategories([category])
        logger.info("📋 Registered notification categories")
    }
    
    // Process any event URL that was stored during launch before appState was available
    func processPendingEvent() {
        logger.info("🔍 Checking for pending event URL...")
        
        // Check memory first
        var urlString = pendingEventURL
        
        // If not in memory, check UserDefaults (persists across app kills)
        if urlString == nil {
            urlString = UserDefaults.standard.string(forKey: "pendingEventURL")
            if urlString != nil {
                logger.info("   Found URL in UserDefaults (from previous launch)")
            }
        }
        
        guard let urlString = urlString else {
            logger.info("   No pending URL found")
            return
        }
        
        logger.info("   Found pending URL: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            logger.error("   ❌ Invalid URL format")
            pendingEventURL = nil
            UserDefaults.standard.removeObject(forKey: "pendingEventURL")
            return
        }
        
        guard let event = Event.fromURL(url) else {
            logger.error("   ❌ Failed to parse event from URL")
            pendingEventURL = nil
            UserDefaults.standard.removeObject(forKey: "pendingEventURL")
            return
        }
        
        logger.notice("   ✅ Successfully parsed event: \(event.title)")
        logger.info("   📍 Address: \(event.address)")
        if let lat = event.latitude, let lng = event.longitude {
            logger.info("   🗺 Coordinates: \(lat), \(lng)")
        }
        
        appState?.currentEvent = event
        pendingEventURL = nil
        UserDefaults.standard.removeObject(forKey: "pendingEventURL")
        logger.notice("   🎉 Event loaded into app state")
    }
    
    // Called when notification is received while app is in foreground
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        logger.info("📬 Notification received in foreground: \(notification.request.content.title)")
        // Show notification even when app is in foreground
        completionHandler([.banner, .sound, .badge])
    }
    
    // Called when user taps on notification
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        logger.notice("👆 User tapped notification: \(response.notification.request.content.title)")
        logger.info("   Action: \(response.actionIdentifier)")
        
        let userInfo = response.notification.request.content.userInfo
        
        // Get event URL from notification
        guard let urlString = userInfo["eventURL"] as? String else {
            logger.error("❌ No eventURL in notification userInfo")
            completionHandler()
            return
        }
        
        logger.info("🔗 Notification tap with event URL: \(urlString)")
        
        // Store URL in UserDefaults for persistence across app launches
        UserDefaults.standard.set(urlString, forKey: "pendingEventURL")
        UserDefaults.standard.synchronize()
        logger.info("💾 Saved event URL to UserDefaults")
        
        // Also store in memory for immediate use
        Task { @MainActor in
            self.pendingEventURL = urlString
            
            // If app state is available, load immediately
            if let appState = self.appState,
               let url = URL(string: urlString),
               let event = Event.fromURL(url) {
                logger.notice("✅ App state available, loading event immediately")
                appState.currentEvent = event
                self.pendingEventURL = nil
                UserDefaults.standard.removeObject(forKey: "pendingEventURL")
            } else {
                logger.info("⏳ App state not ready, URL stored for processing in onAppear")
            }
        }
        
        completionHandler()
    }
}
