import Combine

public protocol ShortcutObserver {
    func observe() 
    var showClipboard: AnyPublisher<Bool, Never> { get }
}
