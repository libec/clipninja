import KeyboardShortcuts
import AppKit
import Combine
import ClipNinja

class KeyboardEventWindow: NSWindow {

    let keySubject = PassthroughSubject<KeyboardShortcuts.Key, Never>()

    private let keyboardController: KeyboardController

    init(
        keyboardController: KeyboardController,
        contentRect: NSRect,
        styleMask style: NSWindow.StyleMask,
        backing backingStoreType: NSWindow.BackingStoreType,
        defer flag: Bool
    ) {
        self.keyboardController = keyboardController
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
    }

    override func keyDown(with event: NSEvent) {
        let keyboardShortcut = KeyboardShortcuts.Key(rawValue: Int(event.keyCode))
        keyboardController.send(keyboardShortcut: keyboardShortcut)
    }
}

final class KeyboardController: KeyboardNotifier {

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
            return .down
        case .upArrow:
            return .up
        case .rightArrow:
            return .right
        case .leftArrow:
            return .left
        case .delete:
            return .delete
        case .keypadEnter, .`return`:
            return .enter
        case .space:
            return .space
        case .escape:
            return .escape
        case .keypad1, .one:
            return .number(number: 1)
        case .keypad2, .two:
            return .number(number: 2)
        case .keypad3, .three:
            return .number(number: 3)
        case .keypad4, .four:
            return .number(number: 4)
        case .keypad5, .five:
            return .number(number: 5)
        case .keypad6, .six:
            return .number(number: 6)
        case .keypad7, .seven:
            return .number(number: 7)
        case .keypad8, .eight:
            return .number(number: 8)
        case .keypad9, .nine:
            return .number(number: 9)
        default:
            return nil
        }
    }
}
