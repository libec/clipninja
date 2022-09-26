import Carbon

final class SystemPasteCommand: PasteCommand {

    init() { }

    func paste() {
        let pasteCommandDown = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(kVK_ANSI_V), keyDown: true)
        pasteCommandDown?.flags = .maskCommand

        let pasteCommandUp = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(kVK_ANSI_V), keyDown: false)
        pasteCommandUp?.flags = .maskCommand

        pasteCommandDown?.post(tap: .cgAnnotatedSessionEventTap)
        pasteCommandUp?.post(tap: .cgAnnotatedSessionEventTap)
    }
}
