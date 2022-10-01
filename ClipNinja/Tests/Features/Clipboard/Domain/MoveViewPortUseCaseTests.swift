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
        let viewPortRepository = InMemoryViewPortRepository()
        viewPortRepository.update(position: position)
        let clipsRepository = ClipsRepositoryAmountStub(numberOfClips: numberOfClips)
        let sut = MoveViewPortUseCaseImpl(
            viewPortRepository: viewPortRepository,
            clipsRepository: clipsRepository
        )

        sut.move(to: movement)

        XCTAssertEqual(viewPortRepository.lastPosition, expectedPosition)
    }
}
