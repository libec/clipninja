import AppKit
import Combine
import KeyboardShortcuts

class KeyboardEventWindow: NSWindow {

    let keySubject = PassthroughSubject<KeyboardShortcuts.Key, Never>()

    private let keyboardController: KeyboardController

    init(
        keyboardController: KeyboardController,
        contentRect: NSRect,
        styleMask style: NSWindow.StyleMask,
        backing backingStoreType: NSWindow.BackingStoreType,
        defer flag: Bool
    ) {
        self.keyboardController = keyboardController
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
    }

    override func keyDown(with event: NSEvent) {
        let keyboardShortcut = KeyboardShortcuts.Key(rawValue: Int(event.keyCode))
        keyboardController.send(keyboardShortcut: keyboardShortcut)
    }
}
