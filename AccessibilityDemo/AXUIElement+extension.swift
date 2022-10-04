//
//  AXUIElement+extension.swift
//  Coontext
//
//  Created by Christian Konrad on 31.08.22.
//

import AppKit

extension AXUIElement {

    func value() throws -> String? {
        try getAttribute(kAXValueAttribute)
    }

    func window() throws -> AXUIElement? {
        try getAttribute(kAXWindowAttribute)
    }

    func clearValue() {
        AXUIElementSetAttributeValue(self, kAXValueAttribute as CFString, "" as CFTypeRef)
    }

    func bounds() -> CGRect? {
        guard let posVal:AXValue = try? getAttribute(kAXPositionAttribute),
              let sizeVal:AXValue = try? getAttribute(kAXSizeAttribute) else { return nil }

        var position = CGPoint.zero
        var size = CGSize.zero

        AXValueGetValue(posVal, AXValueType.cgPoint, &position)
        AXValueGetValue(sizeVal, AXValueType.cgSize, &size)

        return CGRect(origin: position, size: size)
    }

    private func getAttribute<T>(_ attribute: String) throws -> T? {
        var value: AnyObject?
        AXUIElementCopyAttributeValue(self, attribute as CFString, &value)

        if let result = value as? T { return result }
        throw NSError()
    }
    
    static func globalFocusWindow() -> AXUIElement? {
        let systemAXElement = AXUIElementCreateSystemWide()

        if let focusedApp:AXUIElement = try? systemAXElement.getAttribute(kAXFocusedApplicationAttribute) {
            return try? focusedApp.getAttribute(kAXFocusedWindowAttribute)
        }

        return nil
    }

    static func globalFocusUIElement() -> AXUIElement? {
        let systemAXElement = AXUIElementCreateSystemWide()

        if let focusedApp:AXUIElement = try? systemAXElement.getAttribute(kAXFocusedApplicationAttribute) {
            return try? focusedApp.getAttribute(kAXFocusedUIElementAttribute)
        }

        return nil
    }
}
