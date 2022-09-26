import Combine

enum ViewPortMovement {
    case up
    case down
    case left
    case right

    var movementIndexAmount: Int {
        switch self {
        case .up: return -1
        case .down: return 1
        case .left: return -ViewPortConfiguration.clipsPerPage
        case .right: return ViewPortConfiguration.clipsPerPage
        }
    }
}

protocol MoveViewPortUseCase {
    func move(to viewPort: ViewPortMovement)
}

class MoveViewPortUseCaseImpl: MoveViewPortUseCase {

    private let viewPortRepository: ViewPortRepository
    private let clipsRepository: ClipsRepository

    init(
        viewPortRepository: ViewPortRepository,
        clipsRepository: ClipsRepository
    ) {
        self.viewPortRepository = viewPortRepository
        self.clipsRepository = clipsRepository
    }

    func move(to viewPort: ViewPortMovement) {
        let lastPosition = viewPortRepository.lastPosition
        let numberOfClips = clipsRepository.lastClips.count
        let newPosition = max(0, min(lastPosition + viewPort.movementIndexAmount, numberOfClips - 1))
        viewPortRepository.update(position: newPosition)
    }
}
