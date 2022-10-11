@testable import ClipNinja
import Combine

typealias ClipboardsDummy = ClipboardsSpy
class ClipboardsSpy: Clipboards {

    var pinCalled = false
    var deleteCalled = false
    var pastedAtIndex: PasteIndex? = nil
    var movedToViewPort: ViewPortMovement? = nil

    var clips: AnyPublisher<ClipboardViewPort, Never> {
        Empty().eraseToAnyPublisher()
    }

    func pin() {
        pinCalled = true
    }

    func delete() {
        deleteCalled = true
    }

    func paste(at index: PasteIndex) {
        pastedAtIndex = index
    }

    func move(to viewPort: ViewPortMovement) {
        movedToViewPort = viewPort
    }
}

class ClipboardsStub: ClipboardsSpy {

    let subject = PassthroughSubject<ClipboardViewPort, Never>()

    override var clips: AnyPublisher<ClipboardViewPort, Never> {
        subject.eraseToAnyPublisher()
    }
}
