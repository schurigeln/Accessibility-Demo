//
//  FloatingButton.swift
//  AccessibilityDemo
//
//  Created by Christian Konrad on 29.09.22.
//

import AppKit
import SwiftUI

let floatingButtonSize: CGFloat = 40

class FloatingButton: NSPanel, NSWindowDelegate {

    let size = CGSize(width: floatingButtonSize * 2, height: floatingButtonSize)

    override var canBecomeKey: Bool { return false }
    override var canBecomeMain: Bool { return false }

    init(
        position: CGPoint = CGPoint(x: 0, y: 0),
        backing: NSWindow.BackingStoreType = .buffered,
        defer flag: Bool = true
    ) {
        super.init(
            contentRect: CGRect(origin: position, size: size),
            styleMask: [
                .nonactivatingPanel,
                .fullSizeContentView
            ],
            backing: backing, defer: flag
        )

        self.isFloatingPanel = true
        self.level = .floating
        self.isMovable = false

        self.hidesOnDeactivate = false
        self.becomesKeyOnlyIfNeeded = true
        self.acceptsMouseMovedEvents = true

        self.collectionBehavior.insert(.fullScreenAuxiliary)
        self.acceptsMouseMovedEvents = true

        let actionsView = FloatingActionsView()
        let view = NSHostingView(rootView: actionsView)
        self.contentView = view
    }

    public func updatePosition(_ position: CGPoint, windowSize: CGSize) {
        guard let screenHeight = NSScreen.main?.frame.height else { return }

        self.setFrameOrigin(CGPoint(
            x: position.x + windowSize.width - (floatingButtonSize * 2) -  20,
            y: screenHeight - position.y - windowSize.height + 20
        ))
    }

    public func setVisibility(visibilit: Bool) {
        if visibilit {
            self.show()
        } else {
            self.hide()
        }
    }

    private func hide() {
        self.orderOut(self)
    }

    private func show() {
        self.orderFrontRegardless()
        self.makeKeyAndOrderFront(nil)
        self.orderFront(self)
    }
}
