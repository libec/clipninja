import Combine

protocol Clipboards: GetViewPortUseCase, PinUseCase, DeleteUseCase, PasteUseCase, MoveViewPortUseCase { }

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
