import Combine

protocol Clipboards: GetClipsViewPortUseCase, PinUseCase, DeleteUseCase, PasteUseCase, MoveViewPortUseCase { }

final class ClipboardsFacade: Clipboards {

    private let getClipsViewPortUseCase: GetClipsViewPortUseCase
    private let moveViewPortUseCase: MoveViewPortUseCase
    private let pasteUseCase: PasteUseCase
    private let deleteUseCase: DeleteUseCase
    private let pinUseCase: PinUseCase

    init(
        getViewPortUseCase: GetClipsViewPortUseCase,
        moveViewPortUseCase: MoveViewPortUseCase,
        pasteUseCase: PasteUseCase,
        deleteUseCase: DeleteUseCase,
        pinUseCase: PinUseCase
    ) {
        self.moveViewPortUseCase = moveViewPortUseCase
        self.getClipsViewPortUseCase = getViewPortUseCase
        self.pasteUseCase = pasteUseCase
        self.deleteUseCase = deleteUseCase
        self.pinUseCase = pinUseCase
    }

    var clipsViewPort: AnyPublisher<ClipboardViewPort, Never> {
        getClipsViewPortUseCase.clipsViewPort
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
