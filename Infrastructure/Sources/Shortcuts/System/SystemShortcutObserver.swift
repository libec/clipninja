import KeyboardShortcuts
import Logger

extension KeyboardShortcuts.Name {
    static let toggleClipNinja = Self("toggle_clipninja", default: .init(.v, modifiers: [.command, .shift]))
}

final class SystemShortcutObserver: ShortcutObserver {

    init() {
    }

    func observe() {
        log(message: "Listen for shortcut")
        KeyboardShortcuts.onKeyUp(for: .toggleClipNinja) { [self] in
            showClipboard()
        }
    }

    func showClipboard() {
        log(message: "ShowClipboard")
    }
}
