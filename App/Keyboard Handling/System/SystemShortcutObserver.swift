import ClipNinjaPackage
import Combine
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let toggleClipNinja = Self("clipninja_shortcut", default: .init(.v, modifiers: [.command, .shift]))
}

final class SystemShortcutObserver: ShortcutObserver {
    private let subject = PassthroughSubject<Void, Never>()

    init() {}

    func observe() {
        KeyboardShortcuts.onKeyUp(for: .toggleClipNinja) { [self] in
            subject.send(())
        }
    }

    var showClipboard: AnyPublisher<Void, Never> {
        subject.eraseToAnyPublisher()
    }
}
