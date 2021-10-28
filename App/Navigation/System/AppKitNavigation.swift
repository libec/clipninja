import Navigation
import Combine
import Logger
import AppKit

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
                unwrappedSelf.application.windows.forEach { $0.close() }
            }.store(in: &cancellable)
    }

    deinit {
        log(message: "AppKit Navigation deinited")
    }
}
