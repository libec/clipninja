import Combine

final class NavigationImpl: Navigation {
    private let shortcutObserver: ShortcutObserver

    private let navigationSubject = PassthroughSubject<NavigationEvent, Never>()
    private var subscriptions = Set<AnyCancellable>()

    init(shortcutObserver: ShortcutObserver) {
        self.shortcutObserver = shortcutObserver
    }

    public var navigationEvent: AnyPublisher<NavigationEvent, Never> {
        let shortcut: AnyPublisher<NavigationEvent, Never> = shortcutObserver.showClipboard
            .map { _ in .showClipboard }
            .eraseToAnyPublisher()

        return shortcut
            .merge(with: navigationSubject)
            .eraseToAnyPublisher()
    }

    func handle(navigationEvent: NavigationEvent) {
        navigationSubject.send(navigationEvent)
    }
}
