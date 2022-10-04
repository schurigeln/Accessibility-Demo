//
//  FloatingActionsView.swift
//  AccessibilityDemo
//
//  Created by Christian Konrad on 04.10.22.
//

import SwiftUI
import AppKit

struct ActionButton: ButtonStyle {

    @State var hovered: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: floatingButtonSize, height: floatingButtonSize)
            .background(hovered ? Color.blue : Color.clear)
            .cornerRadius(4)
            .foregroundColor(.white)
            .onHover { isHovered in
                self.hovered = isHovered
            }
    }
}

struct FloatingActionsView: View {

    private func clearElementText() {
        guard let element = AXMonitor.activeElement else { return }
        element.clearValue()
    }

    private func copyElementText() {
        guard let element = AXMonitor.activeElement,
              let value = try? element.value() else { return }

        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        pasteBoard.setString(value, forType: .string)
    }

    var body: some View {
        HStack(spacing: 0) {
            Button(
                action: clearElementText,
                label: {Image(systemName: "trash")}
            ).buttonStyle(ActionButton())

            Button(
                action: copyElementText,
                label: {Image(systemName: "doc.on.doc")}
            ).buttonStyle(ActionButton())
        }
    }
}

struct FloatingActionsView_Previews: PreviewProvider {
    static var previews: some View {
        FloatingActionsView()
    }
}
