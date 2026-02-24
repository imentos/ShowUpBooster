//
//  ConfirmationSuccessView.swift
//  ShowUpBooster
//
//  Success sheet shown after confirming attendance
//

import SwiftUI

struct ConfirmationSuccessView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Success Icon
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.1))
                        .frame(width: 100, height: 100)
                    
                    Circle()
                        .fill(Color.green.opacity(0.2))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.green)
                }
                .padding(.top, 24)
                
                // Success Message
                VStack(spacing: 6) {
                    Text("You're All Set!")
                        .font(.title2.bold())
                    
                    Text("We'll keep you on track")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Reminders Info
                VStack(alignment: .leading, spacing: 12) {
                    Text("Your Reminders")
                        .font(.subheadline.bold())
                        .padding(.horizontal)
                    
                    ReminderInfoRow(
                        icon: "bell.fill",
                        title: "1 day before",
                        description: "Tomorrow reminder",
                        color: .blue
                    )
                    
                    ReminderInfoRow(
                        icon: "bell.badge.fill",
                        title: "2 hours before",
                        description: "Time to get ready",
                        color: .orange
                    )
                    
                    ReminderInfoRow(
                        icon: "bell.circle.fill",
                        title: "30 minutes before",
                        description: "Heads up, starting soon",
                        color: .red
                    )
                }
                .padding(.vertical, 12)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Dismiss Button
                Button(action: {
                    dismiss()
                }) {
                    Text("Got It!")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
        }
    }
}

// MARK: - Reminder Info Row Component

struct ReminderInfoRow: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(color.opacity(0.15))
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: icon)
                        .font(.caption)
                        .foregroundColor(color)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption.bold())
                
                Text(description)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "checkmark")
                .font(.caption2.bold())
                .foregroundColor(.green)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
    }
}

// MARK: - Confirmation Status View (for EventDetailView)

struct ConfirmationView: View {
    var body: some View {
        VStack(spacing: 12) {
            // Status Badge
            HStack(spacing: 10) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.title3)
                    .foregroundColor(.green)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Confirmed!")
                        .font(.subheadline.bold())
                        .foregroundColor(.green)
                    
                    Text("You'll receive reminder notifications")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.green.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            
            // Reminder Schedule Card
            VStack(alignment: .leading, spacing: 10) {
                Label("Active Reminders", systemImage: "bell.badge.fill")
                    .font(.caption.bold())
                
                Divider()
                
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.caption2)
                    Text("1 day before")
                        .font(.caption2)
                }
                
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.caption2)
                    Text("2 hours before")
                        .font(.caption2)
                }
                
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.caption2)
                    Text("30 minutes before")
                        .font(.caption2)
                }
            }
            .padding(12)
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }
}

// MARK: - Preview

#Preview("Success Sheet") {
    ConfirmationSuccessView()
}

#Preview("Confirmed Status") {
    ConfirmationView()
}
