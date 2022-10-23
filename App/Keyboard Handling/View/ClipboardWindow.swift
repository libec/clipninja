import AppKit
import ClipNinjaPackage

class ClipboardWindow: KeyboardEventWindow {

    override var frameAutosaveName: NSWindow.FrameAutosaveName {
        "ClipboardWindow"
    }

    override init(
        keyboardController: KeyboardController,
        contentRect: NSRect,
        styleMask style: NSWindow.StyleMask,
        backing backingStoreType: NSWindow.BackingStoreType,
        defer flag: Bool
    ) {
        super.init(keyboardController: keyboardController, contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        titlebarAppearsTransparent = true
        isOpaque = false
        hasShadow = false
        backgroundColor = NSColor(Colors.backgroundColor)
        collectionBehavior = .moveToActiveSpace
    }
}
