import KeyboardShortcuts
import Combine
import ClipNinja

extension KeyboardShortcuts.Name {
    static let toggleClipNinja = Self("aewwsgref", default: .init(.v, modifiers: [.command, .shift]))
}

final class SystemShortcutObserver: ShortcutObserver {

    private let subject = PassthroughSubject<Void, Never>()

    init() {
    }

    func observe() {
        KeyboardShortcuts.onKeyUp(for: .toggleClipNinja) { [self] in
            subject.send(())
        }
    }

    var showClipboard: AnyPublisher<Void, Never> {
        subject.eraseToAnyPublisher()
    }
}
