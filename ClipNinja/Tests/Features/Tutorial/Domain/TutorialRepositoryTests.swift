import Combine
@testable import ClipNinjaPackage
import XCTest

final class TutorialRepositoryTests: XCTestCase {

    func test_returns_welcome_tutorial_for_non_onboarded_users() {
        let tutorialResource = TutorialResourceStub(userOnboard: false)
        let sut = TutorialRepositoryImpl(tutorialResource: tutorialResource)

        sut.checkTutorials(for: .clipsAppear)

        XCTAssertEqual(sut.currentTutorial, .welcome)
    }

    func test_it_returns_nil_for_onboarded_users() {
        let tutorialResource = TutorialResourceStub(userOnboard: true)
        let sut = TutorialRepositoryImpl(tutorialResource: tutorialResource)

        sut.checkTutorials(for: .clipsAppear)

        XCTAssertNil(sut.currentTutorial)
    }

    func test_it_stores_user_onboard_flag_when_finishing_welcome_tutorial() {
        let tutorialResource = TutorialResourceStub(userOnboard: false)
        let sut = TutorialRepositoryImpl(tutorialResource: tutorialResource)
        sut.checkTutorials(for: .clipsAppear)

        sut.finishCurrentTutorial()

        XCTAssertEqual(tutorialResource.storedFlag, .userOnboard)
    }
}

class TutorialResourceStub: TutorialResource {

    let userOnboard: Bool
    var storedFlag: TutorialResourceFlag?

    init(userOnboard: Bool) {
        self.userOnboard = userOnboard
    }

    func store(flag: TutorialResourceFlag) {
        storedFlag = flag
    }
}
