import Combine

protocol Clipboards: GetViewPortUseCase, PinUseCase, DeleteUseCase, PasteUseCase, MoveViewPortUseCase { }

final class ClipboardsFacade: Clipboards {

    private let getViewPortUseCase: GetViewPortUseCase
    private let moveViewPortUseCase: MoveViewPortUseCase
    private let pasteUseCase: PasteUseCase

    init(
        getViewPortUseCase: GetViewPortUseCase,
        moveViewPortUseCase: MoveViewPortUseCase,
        pasteUseCase: PasteUseCase
    ) {
        self.moveViewPortUseCase = moveViewPortUseCase
        self.getViewPortUseCase = getViewPortUseCase
        self.pasteUseCase = pasteUseCase
    }

    var clips: AnyPublisher<ClipboardViewPort, Never> {
        getViewPortUseCase.clips
    }

    func pin() {

    }

    func delete() {

    }

    func paste(at index: PasteIndex) {
        pasteUseCase.paste(at: index)
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
}

enum PasteIndex: Equatable {
    case selected
    case index(_ index: Int)
}
