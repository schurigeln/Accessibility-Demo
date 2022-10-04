//
//  AccessibilityDemoApp.swift
//  AccessibilityDemo
//
//  Created by Christian Konrad on 22.09.22.
//

import SwiftUI

@main
struct AccessibilityDemoApp: App {
    private let axMonitor = AXMonitor()
    
    private func quitApp() {
        NSApplication.shared.terminate(self)
    }

    var body: some Scene {
        MenuBarExtra("Demo", systemImage: "ellipsis.circle.fill") {
            Button("Quit", action: quitApp)

            if !AXMonitor.hasAccessibilityPermissions {
                Button("Grant Accessibility Access", action: AXMonitor.requestAccessibilityPermissions)
            }
        }
    }
}
