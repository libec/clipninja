import KeyboardShortcuts
import Combine

extension KeyboardShortcuts.Name {
    static let toggleClipNinja = Self("aewwf", default: .init(.v, modifiers: [.command, .shift]))
}

final class SystemShortcutObserver: ShortcutObserver {

    private let subject = PassthroughSubject<Bool, Never>()

    init() {
    }

    func observe() {
        log(message: "Listen for shortcut")
        KeyboardShortcuts.onKeyUp(for: .toggleClipNinja) { [self] in
            subject.send(true)
        }
    }

    var showClipboard: AnyPublisher<Bool, Never> {
        subject.eraseToAnyPublisher()
    }
}
