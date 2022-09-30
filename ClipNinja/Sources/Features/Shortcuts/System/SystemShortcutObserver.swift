import KeyboardShortcuts
import Combine

extension KeyboardShortcuts.Name {
    static let toggleClipNinja = Self("aewwsgref", default: .init(.v, modifiers: [.command, .shift]))
}

final class SystemShortcutObserver: ShortcutObserver {

    private let subject = PassthroughSubject<Void, Never>()

    init() {
    }

    func observe() {
        log(message: "Listen for shortcut")
        KeyboardShortcuts.onKeyUp(for: .toggleClipNinja) { [self] in
            print("FOO")
            subject.send(())
        }
    }

    var showClipboard: AnyPublisher<Void, Never> {
        subject.eraseToAnyPublisher()
    }
}
