import Combine

public protocol KeyboardObserver {
    var keyPress: AnyPublisher<KeyboardEvent, Never> { get }
}
