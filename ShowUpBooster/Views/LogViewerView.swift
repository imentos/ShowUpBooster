//
//  LogViewerView.swift
//  ShowUpBooster
//
//  Created for debugging App Clip production issues
//

import SwiftUI

struct LogViewerView: View {
    @Environment(\.dismiss) var dismiss
    @State private var logs: String = ""
    @State private var showCopyConfirmation = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Log count header
                HStack {
                    Text("\(LogManager.shared.getLogs().count) log entries")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Button(action: {
                        LogManager.shared.clearLogs()
                        refreshLogs()
                    }) {
                        Label("Clear", systemImage: "trash")
                            .font(.caption)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                }
                .padding()
                .background(Color(.systemGroupedBackground))
                
                // Log content
                ScrollView {
                    Text(logs.isEmpty ? "No logs yet" : logs)
                        .font(.system(.caption, design: .monospaced))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .textSelection(.enabled)
                }
                .background(Color(.systemBackground))
            }
            .navigationTitle("Debug Logs")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: copyLogs) {
                            Label("Copy to Clipboard", systemImage: "doc.on.doc")
                        }
                        
                        Button(action: shareLogs) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .onAppear {
                refreshLogs()
            }
            .alert("Copied!", isPresented: $showCopyConfirmation) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Logs copied to clipboard")
            }
        }
    }
    
    private func refreshLogs() {
        logs = LogManager.shared.exportLogs()
    }
    
    private func copyLogs() {
        UIPasteboard.general.string = logs
        showCopyConfirmation = true
    }
    
    private func shareLogs() {
        let activityVC = UIActivityViewController(
            activityItems: [logs],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            
            // Find the top-most view controller
            var topVC = rootVC
            while let presented = topVC.presentedViewController {
                topVC = presented
            }
            
            topVC.present(activityVC, animated: true)
        }
    }
}

#Preview {
    LogViewerView()
}
