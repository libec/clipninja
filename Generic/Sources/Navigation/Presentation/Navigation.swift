import Combine

public protocol Navigation {
    var showClipboard: AnyPublisher<Bool, Never> { get }
}
