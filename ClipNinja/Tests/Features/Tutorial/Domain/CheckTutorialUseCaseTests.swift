import Combine
@testable import ClipNinjaPackage
import XCTest

final class CheckTutorialUseCaseTests: XCTestCase {

    func test_it_checks_tutorial_repository_for_events() {
        let repository = TutorialRepositorySpy()
        let navigation = NavigationDummy()
        let sut = CheckTutorialUseCaseImpl(tutorialRepository: repository, navigation: navigation)

        TutorialTriggeringEvent.allCases.forEach { event in
            sut.checkTutorials(for: event)

            XCTAssertEqual(repository.checkedEvent, event)
        }
    }

    func test_it_navigates_to_tutorials_when_repository_returns_tutorial() {
        let repository = TutorialRepositoryStub(tutorialToReturn: .welcome)
        let navigation = NavigationSpy()
        let sut = CheckTutorialUseCaseImpl(tutorialRepository: repository, navigation: navigation)

        sut.checkTutorials(for: .pasteText)

        XCTAssertEqual(navigation.handledEvent, .showTutorial)
    }
}

class TutorialRepositorySpy: TutorialRepository {
    var checkedEvent: TutorialTriggeringEvent?
    var currentTutorial: Tutorial?
    func checkTutorials(for event: TutorialTriggeringEvent) {
        self.checkedEvent = event
    }
}

class TutorialRepositoryStub: TutorialRepository {

    var currentTutorial: Tutorial?

    init(tutorialToReturn: Tutorial) {
        self.currentTutorial = tutorialToReturn
    }

    func checkTutorials(for event: TutorialTriggeringEvent) { }
}
