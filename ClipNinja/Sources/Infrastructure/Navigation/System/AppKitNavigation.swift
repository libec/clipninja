import Combine
import AppKit

// TODO: - Abstract app kit and test
final class AppKitNavigation: Navigation {

    private let shortcutObserver: ShortcutObserver

    private let navigationSubject = PassthroughSubject<NavigationEvent, Never>()
    private var subscriptions = Set<AnyCancellable>()

    init(
        shortcutObserver: ShortcutObserver
    ) {
        self.shortcutObserver = shortcutObserver
    }

    public var navigationEvent: AnyPublisher<NavigationEvent, Never> {
        let resign: AnyPublisher<NavigationEvent, Never> = NotificationCenter.default
            .publisher(
                for: NSApplication.didResignActiveNotification,
                object: nil
            )
            .map { _ in .hideApp }
            .eraseToAnyPublisher()

        let shortcut: AnyPublisher<NavigationEvent, Never>  = shortcutObserver.showClipboard
            .map { _ in .showClipboard }
            .eraseToAnyPublisher()

        return resign.merge(with: shortcut)
            .merge(with: navigationSubject)
            .eraseToAnyPublisher()
    }

    func handle(navigationEvent: NavigationEvent) {
        navigationSubject.send(navigationEvent)
    }
}
