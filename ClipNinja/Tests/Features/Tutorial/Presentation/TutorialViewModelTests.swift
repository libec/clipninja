@testable import ClipNinjaPackage
import XCTest

class TutorialViewModelTests: XCTestCase {
    func test_it_calls_finish_on_dismiss() {
        let tutorials = TutorialsSpy()
        let sut = TutorialViewModelImpl(tutorials: tutorials, navigation: NavigationDummy())

        sut.onEvent(.tutorial(.dismiss))

        XCTAssertTrue(tutorials.finishCalled)
    }

    func test_it_returns_current_tutorial_when_it_appears() {
        for tutorial in Tutorial.allCases {
            let tutorials = TutorialsStub(current: tutorial)
            let sut = TutorialViewModelImpl(tutorials: tutorials, navigation: NavigationDummy())

            sut.onEvent(.lifecycle(.appear))

            XCTAssertEqual(sut.tutorial, tutorial)
        }
    }

    func test_it_shows_settings_for_paste_tutorial() {
        let tutorials = TutorialsStub(current: .pasting)
        let sut = TutorialViewModelImpl(tutorials: tutorials, navigation: NavigationDummy())

        sut.onEvent(.lifecycle(.appear))

        XCTAssertTrue(sut.showSettings)
    }

    func test_showing_settings_finishes_tutorial_and_shows_settings() {
        let tutorials = TutorialsSpy()
        let navigation = NavigationSpy()
        let sut = TutorialViewModelImpl(tutorials: tutorials, navigation: navigation)

        sut.onEvent(.tutorial(.showAppSettings))

        XCTAssertEqual(navigation.allHandledEvents, [.hideTutorial, .showSettings])
        XCTAssertTrue(tutorials.finishCalled)
    }
}

class TutorialsSpy: Tutorials {
    var finishCalled = false

    init() {}

    func getCurrent() -> Tutorial? { nil }

    func finish() {
        finishCalled = true
    }

    func checkTutorials(for _: TutorialTriggeringEvent) {}
}

class TutorialsStub: Tutorials {
    let current: Tutorial

    init(current: Tutorial) {
        self.current = current
    }

    func getCurrent() -> Tutorial? { current }
    func finish() {}
    func checkTutorials(for _: TutorialTriggeringEvent) {}
}
