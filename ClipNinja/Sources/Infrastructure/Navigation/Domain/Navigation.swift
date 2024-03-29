import Combine

public enum NavigationEvent {
    case showClipboard
    case showSettings
    case hideApp
    case showSystemSettings
    case showAppUsage
    case showTutorial
    case hideTutorial

    public var delayedEvent: Bool {
        switch self {
        case .showTutorial:
            true
        case .showClipboard, .showSettings, .hideApp, .showSystemSettings, .showAppUsage, .hideTutorial:
            false
        }
    }

    public var immediateEvent: Bool {
        !delayedEvent
    }
}

public protocol Navigation {
    var navigationEvent: AnyPublisher<NavigationEvent, Never> { get }
    func handle(navigationEvent: NavigationEvent)
}
