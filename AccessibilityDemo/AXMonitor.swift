//
//  AXMonitor.swift
//  AccessibilityDemo
//
//  Created by Christian Konrad on 22.09.22.
//

import SwiftUI
import Combine
import Cocoa

class AXMonitor {

    let interval: Double = 0.2
    let floatingButton = FloatingButton()

    var cancellable: Cancellable?

    init() {

        cancellable = Timer.publish(every: interval, on: .main, in: .default)
            .autoconnect()
            .sink(receiveValue: {_ in

                let showFloatingButton = AXMonitor.hasAccessibilityPermissions && AXMonitor.foregroundApp?.bundleIdentifier == "com.apple.Notes"
                self.floatingButton.setVisibility(visibilit: showFloatingButton)

                guard let element = AXMonitor.activeElement,
                      let bounds = try? element.window()?.bounds() else { return }

                self.floatingButton.updatePosition(bounds.origin, windowSize: bounds.size)
            })
    }

    public static var activeElement: AXUIElement? {
        AXUIElement.globalFocusUIElement()
    }

    public static var foregroundApp: NSRunningApplication? {
        NSWorkspace.shared.frontmostApplication
    }

    public static var hasAccessibilityPermissions: Bool {
        AXIsProcessTrusted()
    }

    public static func requestAccessibilityPermissions() {
        _ = AXIsProcessTrustedWithOptions(
            [kAXTrustedCheckOptionPrompt.takeUnretainedValue(): kCFBooleanTrue] as CFDictionary
        )
    }
}
