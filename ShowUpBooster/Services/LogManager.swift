//
//  LogManager.swift
//  ShowUpBooster
//
//  Simple logging system for App Clip debugging
//

import Foundation

class LogManager {
    static let shared = LogManager()
    
    private let maxLogEntries = 100
    private let logsKey = "AppClipDebugLogs"
    
    private init() {}
    
    struct LogEntry: Codable {
        let timestamp: Date
        let message: String
        let level: LogLevel
        
        enum LogLevel: String, Codable {
            case info = "ℹ️"
            case success = "✅"
            case warning = "⚠️"
            case error = "❌"
            case debug = "🐛"
        }
        
        var formatted: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss.SSS"
            return "[\(formatter.string(from: timestamp))] \(level.rawValue) \(message)"
        }
    }
    
    // MARK: - Logging Methods
    
    func log(_ message: String, level: LogEntry.LogLevel = .info) {
        let entry = LogEntry(timestamp: Date(), message: message, level: level)
        
        // Print to console
        print(entry.formatted)
        
        // Store in UserDefaults
        var logs = getLogs()
        logs.append(entry)
        
        // Keep only last N entries
        if logs.count > maxLogEntries {
            logs = Array(logs.suffix(maxLogEntries))
        }
        
        if let encoded = try? JSONEncoder().encode(logs) {
            UserDefaults.standard.set(encoded, forKey: logsKey)
        }
    }
    
    func info(_ message: String) {
        log(message, level: .info)
    }
    
    func success(_ message: String) {
        log(message, level: .success)
    }
    
    func warning(_ message: String) {
        log(message, level: .warning)
    }
    
    func error(_ message: String) {
        log(message, level: .error)
    }
    
    func debug(_ message: String) {
        log(message, level: .debug)
    }
    
    // MARK: - Retrieval
    
    func getLogs() -> [LogEntry] {
        guard let data = UserDefaults.standard.data(forKey: logsKey),
              let logs = try? JSONDecoder().decode([LogEntry].self, from: data) else {
            return []
        }
        return logs
    }
    
    func getLogsAsString() -> String {
        let logs = getLogs()
        if logs.isEmpty {
            return "No logs available"
        }
        return logs.map { $0.formatted }.joined(separator: "\n")
    }
    
    func clearLogs() {
        UserDefaults.standard.removeObject(forKey: logsKey)
        log("Logs cleared", level: .info)
    }
    
    func exportLogs() -> String {
        let logs = getLogs()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        var export = "ShowUpBooster Debug Logs\n"
        export += "Generated: \(formatter.string(from: Date()))\n"
        export += "Total Entries: \(logs.count)\n"
        export += String(repeating: "=", count: 50) + "\n\n"
        
        for log in logs {
            export += log.formatted + "\n"
        }
        
        return export
    }
}
