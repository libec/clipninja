import ClipNinjaPackage
import Combine
import KeyboardShortcuts

final class SystemKeyboardObserver: KeyboardObserver {
    private let keyPressSubject = PassthroughSubject<KeyboardEvent, Never>()

    var keyPress: AnyPublisher<KeyboardEvent, Never> {
        keyPressSubject.eraseToAnyPublisher()
    }

    func send(keyboardShortcut: KeyboardShortcuts.Key) {
        if let event = keyboardEvent(from: keyboardShortcut) {
            keyPressSubject.send(event)
        }
    }

    private func keyboardEvent(from shortcutsKeyPress: KeyboardShortcuts.Key) -> KeyboardEvent? {
        switch shortcutsKeyPress {
        case .downArrow:
            .down
        case .upArrow:
            .up
        case .rightArrow:
            .right
        case .leftArrow:
            .left
        case .delete:
            .delete
        case .keypadEnter, .return:
            .enter
        case .space:
            .space
        case .escape:
            .escape
        case .keypad1, .one:
            .number(number: 1)
        case .keypad2, .two:
            .number(number: 2)
        case .keypad3, .three:
            .number(number: 3)
        case .keypad4, .four:
            .number(number: 4)
        case .keypad5, .five:
            .number(number: 5)
        case .keypad6, .six:
            .number(number: 6)
        case .keypad7, .seven:
            .number(number: 7)
        case .keypad8, .eight:
            .number(number: 8)
        case .keypad9, .nine:
            .number(number: 9)
        default:
            nil
        }
    }
}
