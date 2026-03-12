//
//  ShareSheet.swift
//  ShowUpBooster
//
//  UIViewControllerRepresentable wrapper for UIActivityViewController
//

import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        print("🎬 ShareSheet: Creating UIActivityViewController with \(items.count) items")
        for (index, item) in items.enumerated() {
            print("  Item \(index): \(type(of: item)) - \(item)")
        }
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        print("✅ ShareSheet: Controller created")
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        print("🔄 ShareSheet: updateUIViewController called")
    }
}
