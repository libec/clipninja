import AppKit
import ClipNinjaPackage
import Combine
import KeyboardShortcuts

class StyledWindow: NSWindow {
    init(contentRect: NSRect) {
        super.init(
            contentRect: contentRect,
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: true
        )
        backgroundColor = NSColor(Colors.backgroundColor)
        hidesOnDeactivate = true
        isReleasedWhenClosed = false
        isMovableByWindowBackground = true
        titlebarAppearsTransparent = true
    }
}

class SettingsWindow: StyledWindow {

    init() {
        super.init(contentRect: NSRect(x: 0, y: 0, width: 450, height: 300))
        title = "ClipNinja Settings"
        setFrameAutosaveName("SettingsWindow")
    }
}

class ClipboardWindow: StyledWindow {

    let keySubject = PassthroughSubject<KeyboardShortcuts.Key, Never>()

    private let keyboardController: KeyboardController

    init(keyboardController: KeyboardController) {
        self.keyboardController = keyboardController
        super.init(contentRect: NSRect(x: 0, y: 0, width: 650, height: 600))
        title = "ClipNinja"
        setFrameAutosaveName("ClipboardWindow")
        collectionBehavior = .canJoinAllSpaces
    }

    override func keyDown(with event: NSEvent) {
        let keyboardShortcut = KeyboardShortcuts.Key(rawValue: Int(event.keyCode))
        keyboardController.send(keyboardShortcut: keyboardShortcut)
    }
}
