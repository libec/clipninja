@testable import ClipNinjaPackage
import Combine

typealias PasteboardObserverDummy = PasteboardObserverStub

class PasteboardObserverStub: PasteboardObserver {

    var subject = PassthroughSubject<String, Never>()

    var newCopiedText: AnyPublisher<String, Never> {
        subject.eraseToAnyPublisher()
    }
}

