import Combine

protocol Clipboards: GetViewPortUseCase, PinUseCase, DeleteUseCase, PasteUseCase, MoveViewPortUseCase { }

final class ClipboardsFacade: Clipboards {

    private let getViewPortUseCase: GetViewPortUseCase
    private let moveViewPortUseCase: MoveViewPortUseCase
    private let pasteUseCase: PasteUseCase
    private let deleteUseCase: DeleteUseCase
    private let pinUseCase: PinUseCase

    init(
        getViewPortUseCase: GetViewPortUseCase,
        moveViewPortUseCase: MoveViewPortUseCase,
        pasteUseCase: PasteUseCase,
        deleteUseCase: DeleteUseCase,
        pinUseCase: PinUseCase
    ) {
        self.moveViewPortUseCase = moveViewPortUseCase
        self.getViewPortUseCase = getViewPortUseCase
        self.pasteUseCase = pasteUseCase
        self.deleteUseCase = deleteUseCase
        self.pinUseCase = pinUseCase
    }

    var clips: AnyPublisher<ClipboardViewPort, Never> {
        getViewPortUseCase.clips
    }

    func pin() {
        pinUseCase.pin()
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
