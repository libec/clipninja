@testable import ClipNinjaPackage
import XCTest

final class CurrentTutorialUseCaseTests: XCTestCase {
    func test_it_checks_with_repository_for_current_tutorial() {
        let tutorials: [Tutorial?] = Tutorial.allCases + [nil]

        for tutorial in tutorials {
            let repository = TutorialRepositoryStub(tutorialToReturn: tutorial)
            let sut = CurrentTutorialUseCaseImpl(repository: repository)

            let current = sut.getCurrent()

            XCTAssertEqual(current, tutorial)
        }
    }
}
