import AppKit
import ClipNinjaPackage

class SettingsWindow: NSWindow {

    init() {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 450, height: 300),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: true
        )
        title = "ClipNinja Settings"
        backgroundColor = NSColor(Colors.prominent)
        setFrameAutosaveName("SettingsWindow")
        hidesOnDeactivate = true
        isReleasedWhenClosed = false
    }
}
