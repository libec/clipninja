import Combine
@testable import ClipNinjaPackage
import XCTest

final class TutorialRepositoryTests: XCTestCase {

    func test_returns_welcome_tutorial_for_non_onboarded_users() {
        let resource = LocalTutorialResource()
        let sut = TutorialRepositoryImpl(resource: resource)

        sut.checkTutorials(for: .clipsAppear)

        XCTAssertEqual(sut.currentTutorial, .welcome)
    }

    func test_it_returns_nil_for_onboarded_users() {
        let resource = LocalTutorialResource()
        resource.set(flag: .onboard)
        let sut = TutorialRepositoryImpl(resource: resource)

        sut.checkTutorials(for: .clipsAppear)

        XCTAssertNil(sut.currentTutorial)
    }

    func test_it_stores_user_onboard_flag_when_finishing_welcome_tutorial() {
        let resource = LocalTutorialResource()
        let sut = TutorialRepositoryImpl(resource: resource)
        sut.checkTutorials(for: .clipsAppear)

        sut.finishCurrentTutorial()

        XCTAssertTrue(resource.contains(flag: .onboard))
        XCTAssertNil(sut.currentTutorial)
    }

    func test_returns_paste_tutorial_when_pasting_for_the_first_time() {
        let resource = LocalTutorialResource()
        let sut = TutorialRepositoryImpl(resource: resource)

        sut.checkTutorials(for: .pasteText)

        XCTAssertEqual(sut.currentTutorial, .pasting)
    }

    func test_it_stores_paste_text_flag_when_finishing_pasting_tutorial() {
        let resource = LocalTutorialResource()
        let sut = TutorialRepositoryImpl(resource: resource)
        sut.checkTutorials(for: .pasteText)

        sut.finishCurrentTutorial()

        XCTAssertTrue(resource.contains(flag: .pasteText))
        XCTAssertNil(sut.currentTutorial)
    }
}
