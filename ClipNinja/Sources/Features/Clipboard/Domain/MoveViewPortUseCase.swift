import Combine

enum ViewPortMovement {
    case up
    case down
    case left
    case right
}

protocol MoveViewPortUseCase {
    func move(to viewPort: ViewPortMovement)
}

class MoveViewPortUseCaseImpl: MoveViewPortUseCase {
    private let viewPortRepository: ViewPortRepository
    private let clipsRepository: ClipsRepository
    private let viewPortConfiguration: ViewPortConfiguration
    private let checkTutorialUseCase: CheckTutorialUseCase

    init(
        viewPortRepository: ViewPortRepository,
        clipsRepository: ClipsRepository,
        viewPortConfiguration: ViewPortConfiguration,
        checkTutorialUseCase: CheckTutorialUseCase
    ) {
        self.viewPortRepository = viewPortRepository
        self.clipsRepository = clipsRepository
        self.viewPortConfiguration = viewPortConfiguration
        self.checkTutorialUseCase = checkTutorialUseCase
    }

    func move(to viewPort: ViewPortMovement) {
        let lastPosition = viewPortRepository.lastPosition
        let numberOfClips = clipsRepository.lastClips.count
        let newPosition = max(0, min(lastPosition + movementAmount(for: viewPort), numberOfClips - 1))
        viewPortRepository.update(position: newPosition)
        checkTutorialUseCase.checkTutorials(for: .clipsMovement)
    }

    private func movementAmount(for viewPortMovement: ViewPortMovement) -> Int {
        switch viewPortMovement {
        case .up: return -1
        case .down: return 1
        case .left: return -viewPortConfiguration.clipsPerPage
        case .right: return viewPortConfiguration.clipsPerPage
        }
    }
}
