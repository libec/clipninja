import Combine

public protocol ShortcutObserver {
    func observe() 
    var showClipboard: AnyPublisher<Void, Never> { get }
}
