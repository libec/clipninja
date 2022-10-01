import Combine
import AppKit
import SwiftUI

final class AppKitNavigation: Navigation {

    private let shortcutObserver: ShortcutObserver
    private let hideSubject = PassthroughSubject<Void, Never>()

    init(
        shortcutObserver: ShortcutObserver
    ) {
        self.shortcutObserver = shortcutObserver
    }

    var showClipboard: AnyPublisher<Bool, Never> {
        let resign = NotificationCenter.default
            .publisher(
                for: NSApplication.didResignActiveNotification,
                object: nil
            )
            .map { _ in false }
            .eraseToAnyPublisher()

        let shortcut = shortcutObserver.showClipboard
            .map { _ in true }
            .eraseToAnyPublisher()

        let hide = hideSubject.map { _ in false }
            .eraseToAnyPublisher()

        /*
         store app when going to foreground
         */

        return resign.merge(with: shortcut)
            .merge(with: hide)
            .eraseToAnyPublisher()
    }

    func hide() {
        hideSubject.send(())
    }

    private func showPreviousApp() {
        /*
         1. switch app
         2. remove stored app from background
         */
    }
}
