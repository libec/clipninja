import Combine

public protocol Navigation {
    var closeActiveWindows: AnyPublisher<Void, Never> { get }
}
