import Combine
@testable import ClipNinjaPackage
import XCTest

final class TutorialRepositoryTests: XCTestCase {

    func test_returns_welcome_tutorial_for_non_onboarded_users() {
        let tutorialResource = LocalTutorialResource()
        let sut = TutorialRepositoryImpl(tutorialResource: tutorialResource)

        sut.checkTutorials(for: .clipsAppear)

        XCTAssertEqual(sut.currentTutorial, .welcome)
    }

    func test_it_returns_nil_for_onboarded_users() {
        let tutorialResource = LocalTutorialResource()
        tutorialResource.set(flag: .onboard)
        let sut = TutorialRepositoryImpl(tutorialResource: tutorialResource)

        sut.checkTutorials(for: .clipsAppear)

        XCTAssertNil(sut.currentTutorial)
    }

    func test_it_stores_user_onboard_flag_when_finishing_welcome_tutorial() {
        let tutorialResource = LocalTutorialResource()
        let sut = TutorialRepositoryImpl(tutorialResource: tutorialResource)
        sut.checkTutorials(for: .clipsAppear)

        sut.finishCurrentTutorial()

        XCTAssertTrue(tutorialResource.contains(flag: .onboard))
        XCTAssertNil(sut.currentTutorial)
    }
}
