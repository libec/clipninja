import Combine
import XCTest
@testable import ClipNinjaPackage

class ResetViewPortUseCaseTests: XCTestCase {

    func test_it_rests_viewport_to_zero() {
        let viewPortRepository = InMemoryViewPortRepository()
        viewPortRepository.update(position: 5)
        let sut = ResetViewPortUseCaseImpl(
            viewPortRepository: viewPortRepository
        )

        sut.reset()

        XCTAssertEqual(viewPortRepository.lastPosition, 0)
    }
}
