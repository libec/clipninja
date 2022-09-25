import Combine

protocol Clipboards: GetViewPortUseCase, PinUseCase, DeleteUseCase, PasteUseCase, MoveViewPortUseCase { }

struct ClipboardViewPort {
    let clips: [Clip]
    let selectedTab: Int
    let numberOfTabs: Int
}

protocol GetViewPortUseCase {
    var clips: AnyPublisher<ClipboardViewPort, Never> { get }
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

protocol PasteUseCase {
    func paste(at index: PasteIndex)
}

enum ViewPortMovement {
    case up
    case down
    case left
    case right
}

protocol MoveViewPortUseCase {
    func move(to viewPort: ViewPortMovement)
}
