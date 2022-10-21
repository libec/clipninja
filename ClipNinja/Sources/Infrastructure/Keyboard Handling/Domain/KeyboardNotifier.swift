import Combine

public protocol KeyboardNotifier {
    var keyPress: AnyPublisher<KeyboardEvent, Never> { get }
}
