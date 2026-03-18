//
//  ShowUpBoosterApp.swift
//  ShowUpBooster
//
//  Created by Kuo, Ray on 2/23/26.
//

import SwiftUI
import Combine
import os

private let logger = Logger(subsystem: "com.showupbooster.app", category: "FullApp")

@main
struct ShowUpBoosterApp: App {
    @StateObject private var appState = AppState()
    
    init() {
        logger.info("🚀 ShowUpBooster Full App is launching...")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(appState: appState)
                .onAppear {
                    logger.info("👀 App appeared - checking for launch URL")
                    // Check for environment variable (used in Xcode testing)
                    if let urlString = ProcessInfo.processInfo.environment["_XCAppClipURL"] {
                        logger.info("   ✅ Found _XCAppClipURL: \(urlString)")
                        if let url = URL(string: urlString) {
                            handleIncomingURL(url)
                        }
                    } else {
                        logger.info("   ℹ️ No launch URL in environment")
                    }
                }
                .onOpenURL { url in
                    logger.info("📨 onOpenURL triggered: \(url.absoluteString)")
                    handleIncomingURL(url)
                }
                .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { userActivity in
                    logger.info("🌐 onContinueUserActivity triggered for web browsing")
                    if let url = userActivity.webpageURL {
                        logger.info("   URL from user activity: \(url.absoluteString)")
                        handleIncomingURL(url)
                    } else {
                        logger.warning("   ⚠️ No webpage URL in user activity")
                    }
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
