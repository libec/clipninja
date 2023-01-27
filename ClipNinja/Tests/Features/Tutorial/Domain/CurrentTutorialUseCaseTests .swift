@testable import ClipNinjaPackage
import XCTest

final class CurrentTutorialUseCaseTests: XCTestCase {

    func test_it_checks_with_repository_for_current_tutorial() {
        let tutorials: [Tutorial?] = Tutorial.allCases + [nil]

        tutorials.forEach {
            let repository = TutorialRepositoryStub(tutorialToReturn: $0)
            let sut = CurrentTutorialUseCaseImpl(repository: repository)

            let current = sut.getCurrent()

            XCTAssertEqual(current, $0)
        }
    }
}
