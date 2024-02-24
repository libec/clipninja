@testable import ClipNinjaPackage
import Combine
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
    var finishCurrentTutorialCalled = false
    func checkTutorials(for event: TutorialTriggeringEvent) {
        checkedEvent = event
    }

    func finishCurrentTutorial() {
        finishCurrentTutorialCalled = true
    }
}

class TutorialRepositoryStub: TutorialRepository {
    var currentTutorial: Tutorial?

    init(tutorialToReturn: Tutorial?) {
        currentTutorial = tutorialToReturn
    }

    func checkTutorials(for _: TutorialTriggeringEvent) {}
    func finishCurrentTutorial() {}
}
