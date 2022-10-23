import AppKit
import ClipNinjaPackage

class SettingsWindow: NSWindow {

    override var frameAutosaveName: NSWindow.FrameAutosaveName {
        "SettingsWindow"
    }

    override init(
        contentRect: NSRect,
        styleMask style: NSWindow.StyleMask,
        backing backingStoreType: NSWindow.BackingStoreType,
        defer flag: Bool
    ) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
//        titlebarAppearsTransparent = true
//        isOpaque = false
//        hasShadow = false
        backgroundColor = NSColor(Colors.prominent)
        setFrameAutosaveName("SettingsWindow")
    }
}
