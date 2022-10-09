import Combine

protocol Clipboards: GetViewPortUseCase, PinUseCase, DeleteUseCase, PasteUseCase, MoveViewPortUseCase { }

final class ClipboardsFacade: Clipboards {

    private let getViewPortUseCase: GetViewPortUseCase
    private let moveViewPortUseCase: MoveViewPortUseCase
    private let pasteUseCase: PasteUseCase
    private let deleteUseCase: DeleteUseCase

    init(
        getViewPortUseCase: GetViewPortUseCase,
        moveViewPortUseCase: MoveViewPortUseCase,
        pasteUseCase: PasteUseCase,
        deleteUseCase: DeleteUseCase
    ) {
        self.moveViewPortUseCase = moveViewPortUseCase
        self.getViewPortUseCase = getViewPortUseCase
        self.pasteUseCase = pasteUseCase
        self.deleteUseCase = deleteUseCase
    }

    var clips: AnyPublisher<ClipboardViewPort, Never> {
        getViewPortUseCase.clips
    }

    func pin() {

    }

    func delete() {
        deleteUseCase.delete()
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

enum PasteIndex: Equatable {
    case selected
    case index(_ index: Int)
}
