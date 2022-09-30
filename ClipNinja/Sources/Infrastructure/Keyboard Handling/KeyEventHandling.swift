import Carbon
import SwiftUI

struct KeyEventHandling: NSViewRepresentable {

    let onKeyPress: (KeyPress)->Void

    func makeNSView(context: Context) -> NSView {
        let keyView = KeyView()
        keyView.onKeyPress = onKeyPress
        return keyView
    }

    func updateNSView(_ nsView: NSView, context: Context) { }
}

class KeyView: NSView {

    var onKeyPress: ((KeyPress)->Void)?

    override var acceptsFirstResponder: Bool { true }
    
    override func keyDown(with event: NSEvent) {
        if let key = Key(rawValue: event.keyCode) {
            onKeyPress?(.key(key))
        }
        if let numericKey = NumericKey(rawValue: event.keyCode) {
            onKeyPress?(.numeric(numericKey))
        }
    }
}

