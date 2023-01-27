import Combine
@testable import ClipNinjaPackage
import XCTest

final class TutorialRepositoryTests: XCTestCase {

    func test_returns_welcome_tutorial_for_non_onboarded_users() {
        let sut = makeSut()

        sut.checkTutorials(for: .clipsAppear)

        XCTAssertEqual(sut.currentTutorial, .welcome)
    }

    func test_it_returns_nil_for_onboarded_users() {
        let resource = LocalTutorialResource()
        resource.set(flag: .onboard)
        let sut = makeSut(resource: resource)

        sut.checkTutorials(for: .clipsAppear)

        XCTAssertNil(sut.currentTutorial)
    }

    func test_it_stores_user_onboard_flag_when_finishing_welcome_tutorial() {
        let resource = LocalTutorialResource()
        let sut = makeSut(resource: resource)
        sut.checkTutorials(for: .clipsAppear)

        sut.finishCurrentTutorial()

        XCTAssertTrue(resource.contains(flag: .onboard))
        XCTAssertNil(sut.currentTutorial)
    }

    func test_returns_paste_tutorial_when_pasting_for_the_first_time_and_permsisions_not_granted() {
        let permissionsResource = PermissionsResourceStub(pastingAllowed: false)
        let sut = makeSut(permissionsResource: permissionsResource)

        sut.checkTutorials(for: .pasteText)

        XCTAssertEqual(sut.currentTutorial, .pasting)
    }

    func test_it_stores_paste_text_flag_when_finishing_pasting_tutorial() {
        let resource = LocalTutorialResource()
        let sut = makeSut(resource: resource)
        sut.checkTutorials(for: .pasteText)

        sut.finishCurrentTutorial()

        XCTAssertTrue(resource.contains(flag: .pasteText))
        XCTAssertNil(sut.currentTutorial)
    }

    func test_it_skips_pasting_tutorial_when_permissions_are_already_granted() {
        let permissionsResource = PermissionsResourceStub(pastingAllowed: true)
        let sut = makeSut(permissionsResource: permissionsResource)

        sut.checkTutorials(for: .pasteText)

        XCTAssertNil(sut.currentTutorial)
    }

    private func makeSut(
        resource: TutorialResource = LocalTutorialResource(),
        permissionsResource: PermissionsResource = PermissionsResourceStub(pastingAllowed: false)
    ) -> TutorialRepositoryImpl {
        TutorialRepositoryImpl(
            resource: resource,
            permissionsResource: permissionsResource
        )
    }
}
