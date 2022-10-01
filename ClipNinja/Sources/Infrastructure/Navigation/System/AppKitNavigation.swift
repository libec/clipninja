import Combine
import AppKit
import SwiftUI

final class AppKitNavigation: Navigation {

    private let shortcutObserver: ShortcutObserver
    private let hideSubject = PassthroughSubject<Void, Never>()

    private var subscriptions = Set<AnyCancellable>()

    init(
        shortcutObserver: ShortcutObserver
    ) {
        self.shortcutObserver = shortcutObserver
    }

    private var showClipboard: AnyPublisher<Bool, Never> {
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

    func subscribe() {
        showClipboard.receive(on: DispatchQueue.main)
            .sink { show in
                if show {
                    NSApp.activate(ignoringOtherApps: true)
                } else {
                    NSApp.hide(self)
                }
            }.store(in: &subscriptions)
    }

    private func showPreviousApp() {
        /*
         1. switch app
         2. remove stored app from background
         */
    }
}
