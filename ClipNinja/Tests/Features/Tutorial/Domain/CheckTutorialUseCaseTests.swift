import Combine
@testable import ClipNinjaPackage
import XCTest

final class CheckTutorialUseCaseTests: XCTestCase {

    func test_it_shows_tutorial_when_clips_appear_for_the_first_time() {
        let navigation = NavigationSpy()
        let resource = TutorialResourceStub(wentThrough: false)
        let sut = makeSut(navigation: navigation, tutorialResource: resource)

        sut.check(with: .clipsAppear)

        XCTAssertEqual(navigation.handledEvent, .showTutorialOnClips)
    }

    func test_it_shows_tutorial_when_user_asks_for_one() {
        let navigation = NavigationSpy()
        let resource = TutorialResourceStub(wentThrough: false)
        let sut = makeSut(navigation: navigation, tutorialResource: resource)

        sut.check(with: .user)

        XCTAssertEqual(navigation.handledEvent, .showTutorial)
    }

    private func makeSut(navigation: Navigation, tutorialResource: TutorialResource) -> CheckTutorialUseCaseImpl {
        CheckTutorialUseCaseImpl(
            tutorialRepository: TutorialRepositoryImpl(tutorialResource: tutorialResource),
            navigation: navigation
        )
    }
}
