@testable import ClipNinjaPackage
import XCTest

final class FinishCurrentTutorialUseCaseTests: XCTestCase {

    func test_it_uses_repository_to_finish_and_navigates_to_hide_tutorials() {
        let repository = TutorialRepositorySpy()
        let navigation = NavigationSpy()
        let sut = FinishCurrentTutorialUseCaseImpl(repository: repository, navigation: navigation)

        sut.finish()

        XCTAssertTrue(repository.finishCurrentTutorialCalled)
        XCTAssertEqual(navigation.handledEvent, .hideTutorial)
    }
}
