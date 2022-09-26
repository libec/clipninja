import Combine
import XCTest
@testable import ClipNinja

class MoveViewPortUseCaseTests: XCTestCase {

    func test_moves_within_bounds_are_updated() {
        runTests(numberOfClips: 4, position: 2, movement: .down, expectedPosition: 3)
        runTests(numberOfClips: 20, position: 2, movement: .right, expectedPosition: 11)
        runTests(numberOfClips: 5, position: 3, movement: .up, expectedPosition: 2)
        runTests(numberOfClips: 19, position: 17, movement: .left, expectedPosition: 8)
    }

    func test_moves_outside_bounds_are_discarded() {
        runTests(numberOfClips: 4, position: 3, movement: .down, expectedPosition: 3)
        runTests(numberOfClips: 14, position: 4, movement: .right, expectedPosition: 13)
        runTests(numberOfClips: 20, position: 0, movement: .up, expectedPosition: 0)
        runTests(numberOfClips: 20, position: 7, movement: .left, expectedPosition: 0)
    }

    func runTests(
        numberOfClips: Int,
        position: Int,
        movement: ViewPortMovement,
        expectedPosition: Int
    ) {
        let viewPortRepository = ViewPortRepositorySpy()
        viewPortRepository.lastPosition = position
        let clipsRepository = ClipsRepositoryStub()
        clipsRepository.numberOfClips = numberOfClips
        let sut = MoveViewPortUseCaseImpl(
            viewPortRepository: viewPortRepository,
            clipsRepository: clipsRepository
        )

        sut.move(to: movement)

        XCTAssertEqual(viewPortRepository.newPosition, expectedPosition)
    }
}

class ViewPortRepositorySpy: ViewPortRepository {

    var newPosition: Int = Int.min

    var position: AnyPublisher<Int, Never> {
        Just(lastPosition)
            .eraseToAnyPublisher()
    }

    func update(position: Int) {
        newPosition = position
    }

    var lastPosition: Int = 0
}

class ClipsRepositoryStub: ClipsRepository {
    var clips: AnyPublisher<[Clip], Never> {
        Just(lastClips)
            .eraseToAnyPublisher()
    }

    var lastClips: [Clip] {
        return (0..<numberOfClips).map { _ in
            Clip(text: "", pinned: false, selected: false)
        }
    }

    var numberOfClips: Int = 0
}
