@testable import ClipNinjaPackage
import XCTest

final class FinishCurrentTutorialUseCaseTests: XCTestCase {

    func test_it_checks_with_repository_for_current_tutorial() {
        let repository = TutorialRepositorySpy()
        let sut = FinishCurrentTutorialUseCaseImpl(repository: repository)

        sut.finish()

        XCTAssertTrue(repository.finishCurrentTutorialCalled)
    }
}
