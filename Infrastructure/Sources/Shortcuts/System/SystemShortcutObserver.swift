import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let toggleClipNinja = Self("toggle_clipninja", default: .init(.v, modifiers: [.command, .shift]))
}

final class SystemShortcutObserver: ShortcutObserver {

    init() {
    }

    func observe() {
        KeyboardShortcuts.onKeyUp(for: .toggleClipNinja) { [self] in
            showClipboard()
        }
    }

    func showClipboard() {
        print("SHOW STUFF")
    }
}
