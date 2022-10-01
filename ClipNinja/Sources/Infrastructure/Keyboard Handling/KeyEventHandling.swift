import Carbon
import SwiftUI
import KeyboardShortcuts

struct KeyEventHandling: NSViewRepresentable {

    let onKeyPress: (KeyboardShortcuts.Key)->Void

    func makeNSView(context: Context) -> NSView {
        let keyView = KeyView()
        keyView.onKeyPress = onKeyPress
        return keyView
    }

    func updateNSView(_ nsView: NSView, context: Context) { }
}

class KeyView: NSView {

    var onKeyPress: ((KeyboardShortcuts.Key)->Void)?

    override var acceptsFirstResponder: Bool { true }
    
    override func keyDown(with event: NSEvent) {
        let keyboardShortcut = KeyboardShortcuts.Key(rawValue: Int(event.keyCode))
        onKeyPress?(keyboardShortcut)
    }
}

