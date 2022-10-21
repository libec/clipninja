import Combine
import Foundation
import AppKit

protocol PasteboardObserver {
    var newCopiedText: AnyPublisher<String, Never> { get }
}

struct PasteboardObserverImpl: PasteboardObserver {

    private let pasteboard: NSPasteboard

    let newCopiedText: AnyPublisher<String, Never>

    init(pasteboard: NSPasteboard) {
        self.pasteboard = pasteboard

        self.newCopiedText = Timer.publish(every: 0.5, on: .main, in: .default)
            .autoconnect()
            .map { _ in pasteboard.changeCount }
            .removeDuplicates()
            .compactMap { _ in pasteboard.string(forType: .string) }
            .dropFirst()
            .eraseToAnyPublisher()
    }
}
