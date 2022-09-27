import Carbon
import SwiftUI

struct KeyEventHandling: NSViewRepresentable {

    class KeyView: NSView {

        override var acceptsFirstResponder: Bool { true }

        override func keyDown(with event: NSEvent) {
            print("\(event.keyCode)")
            print(CGKeyCode(kVK_ANSI_KeypadEnter))
            if let key = Key(rawValue: event.keyCode) {
                log(message: "\(key)")
            }
            if let numericKey = NumericKey(rawValue: event.keyCode) {
                log(message: "\(numericKey)")
            }
        }
    }

    func makeNSView(context: Context) -> NSView {
        KeyView()
    }

    func updateNSView(_ nsView: NSView, context: Context) { }
}

