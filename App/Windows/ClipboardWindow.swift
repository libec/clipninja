import AppKit
import ClipNinjaPackage
import Combine
import KeyboardShortcuts

class ClipboardWindow: NSWindow {

    let keySubject = PassthroughSubject<KeyboardShortcuts.Key, Never>()

    private let keyboardController: KeyboardController

    init(keyboardController: KeyboardController) {
        self.keyboardController = keyboardController
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 650, height: 600),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: true
        )
        titlebarAppearsTransparent = true
        isOpaque = false
        backgroundColor = NSColor(Colors.backgroundColor)
        collectionBehavior = .moveToActiveSpace
        isMovableByWindowBackground = true
        setFrameAutosaveName("ClipboardWindow")
        hidesOnDeactivate = true
        isReleasedWhenClosed = false
    }

    override func keyDown(with event: NSEvent) {
        let keyboardShortcut = KeyboardShortcuts.Key(rawValue: Int(event.keyCode))
        keyboardController.send(keyboardShortcut: keyboardShortcut)
    }
}
