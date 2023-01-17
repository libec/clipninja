import Combine

public enum NavigationEvent {
    case showClipboard
    case showSettings
    case hideApp
    case showSystemSettings
    case showTutorialOnClips
    case showTutorial
}

public protocol Navigation {
    var navigationEvent: AnyPublisher<NavigationEvent, Never> { get }
    func handle(navigationEvent: NavigationEvent)
}
