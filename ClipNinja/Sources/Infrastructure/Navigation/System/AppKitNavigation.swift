import Combine
import AppKit
import SwiftUI

final class AppKitNavigation: Navigation {

    private let shortcutObserver: ShortcutObserver

    init(
        shortcutObserver: ShortcutObserver
    ) {
        self.shortcutObserver = shortcutObserver
    }

    var showClipboard: AnyPublisher<Bool, Never> {
        let resign = NotificationCenter.default.publisher(for: NSApplication.didResignActiveNotification, object: nil)
            .map { _ in false }
            .eraseToAnyPublisher()

        let shortcut = shortcutObserver.showClipboard
            .map { _ in true }
            .eraseToAnyPublisher()

        /*
         store app when going to foreground
         */

        return resign.merge(with: shortcut).eraseToAnyPublisher()
    }

    func showPreviousApp() {
        /*
         1. switch app
         2. remove stored app from background
         */
    }


    deinit {
        log(message: "AppKit Navigation deinited")
    }
}
