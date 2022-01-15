import Navigation
import Combine
import Logger
import AppKit
import SwiftUI
import Clipboard

final class AppKitNavigation: Navigation {

    private let application: NSApplication

    init(application: NSApplication) {
        self.application = application
    }

    var closeActiveWindows: AnyPublisher<Void, Never> {
        NotificationCenter.default.publisher(for: NSApplication.didResignActiveNotification, object: nil)
            .map { _ in }
            .eraseToAnyPublisher()
    }

    deinit {
        log(message: "AppKit Navigation deinited")
    }
}
