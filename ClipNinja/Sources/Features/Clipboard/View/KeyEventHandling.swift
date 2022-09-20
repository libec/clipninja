import Carbon
import SwiftUI

struct KeyEventHandling: NSViewRepresentable {

    class KeyView: NSView {
        override var acceptsFirstResponder: Bool { true }

        override func keyDown(with event: NSEvent) {
            print("\(event.keyCode)")
            print(CGKeyCode(kVK_ANSI_KeypadEnter))
        }
    }

    func makeNSView(context: Context) -> NSView {
        KeyView()
    }

    func updateNSView(_ nsView: NSView, context: Context) { }
}
