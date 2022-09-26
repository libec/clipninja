import Combine

protocol Clipboards: GetViewPortUseCase, PinUseCase, DeleteUseCase, PasteUseCase, MoveViewPortUseCase { }

final class ClipboardsFacade: Clipboards {

    private let getViewPortUseCase: GetViewPortUseCase
    private let moveViewPortUseCase: MoveViewPortUseCase

    init(
        getViewPortUseCase: GetViewPortUseCase,
        moveViewPortUseCase: MoveViewPortUseCase
    ) {
        self.moveViewPortUseCase = moveViewPortUseCase
        self.getViewPortUseCase = getViewPortUseCase
    }

    var clips: AnyPublisher<ClipboardViewPort, Never> {
        getViewPortUseCase.clips
    }

    func pin() {

    }

    func delete() {

    }

    func paste(at index: PasteIndex) {

    }

    func move(to viewPort: ViewPortMovement) {
        moveViewPortUseCase.move(to: viewPort)
    }
}

protocol PinUseCase {
    func pin()
}

protocol DeleteUseCase {
    func delete()
    // TODO: - Delete should update ViewPort as well
}

enum PasteIndex: Equatable {
    case selected
    case index(_ index: Int)
}

protocol PasteUseCase {
    func paste(at index: PasteIndex)
}
