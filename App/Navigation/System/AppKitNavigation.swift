import Navigation
import Combine
import Logger
import AppKit
import SwiftUI

public final class AppKitNavigation: Navigation {

    private var cancellable = Set<AnyCancellable>()

    private let application: NSApplication

    init(application: NSApplication) {
        self.application = application
        
        NotificationCenter.default.publisher(for: NSApplication.didResignActiveNotification, object: nil)
            .print("Navigation Stream")
            .sink { [weak self] value in
                log(message: "\(value)")
                guard let unwrappedSelf = self else { return }

                application.windows.forEach { window in

                    log(message: "\(window.contentView)")
                }

            }.store(in: &cancellable)
    }

    deinit {
        log(message: "AppKit Navigation deinited")
    }
}
