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
}

class TutorialResourceStub: TutorialResource {

    let userOnboard: Bool

    init(userOnboard: Bool) {
        self.userOnboard = userOnboard
    }
}
