import Combine
import AppKit
import SwiftUI
import Infrastructure

final class AppKitNavigation: Navigation {

    private let application: NSApplication
    private let shortcutObserver: ShortcutObserver

    init(
        application: NSApplication,
        shortcutObserver: ShortcutObserver
    ) {
        self.application = application
        self.shortcutObserver = shortcutObserver
    }

    var showClipboard: AnyPublisher<Bool, Never> {
        let resign = NotificationCenter.default.publisher(for: NSApplication.didResignActiveNotification, object: nil)
            .map { _ in false }
            .eraseToAnyPublisher()

        let shortcut = shortcutObserver.showClipboard
            .eraseToAnyPublisher()

        return resign.merge(with: shortcut).eraseToAnyPublisher()
    }

    deinit {
        log(message: "AppKit Navigation deinited")
    }
}
