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
        isMovableByWindowBackground = true
        titlebarAppearsTransparent = true
        isReleasedWhenClosed = false
    }
}

class SettingsWindow: StyledWindow {

    init() {
        super.init(contentRect: NSRect(x: 0, y: 0, width: 450, height: 300))
        title = Strings.Settings.windowName
        setFrameAutosaveName("SettingsWindow")
        hidesOnDeactivate = false
    }
}

class TutorialWindow: StyledWindow {

    init() {
        super.init(contentRect: NSRect(x: 0, y: 0, width: 500, height: 400))
        setFrameAutosaveName("TutorialWindow")
        hidesOnDeactivate = true
    }
}

class ClipboardWindow: StyledWindow {

    let keySubject = PassthroughSubject<KeyboardShortcuts.Key, Never>()

    private let keyboardController: SystemKeyboardObserver

    init(keyboardController: SystemKeyboardObserver) {
        self.keyboardController = keyboardController
        super.init(contentRect: NSRect(x: 0, y: 0, width: 650, height: 600))
        title = Strings.Generic.appName
        setFrameAutosaveName("ClipboardWindow")
        collectionBehavior = [.moveToActiveSpace]
        hidesOnDeactivate = true
    }

    override func keyDown(with event: NSEvent) {
        let keyboardShortcut = KeyboardShortcuts.Key(rawValue: Int(event.keyCode))
        keyboardController.send(keyboardShortcut: keyboardShortcut)
    }
}
