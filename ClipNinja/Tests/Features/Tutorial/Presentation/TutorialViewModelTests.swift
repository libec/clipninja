@testable import ClipNinjaPackage
import XCTest

class TutorialViewModelTests: XCTestCase {

    func test_it_calls_finish_on_dismiss() {
        let tutorials = TutorialsSpy()
        let sut = TutorialViewModelImpl(tutorials: tutorials)

        sut.onEvent(.tutorial(.dismiss))

        XCTAssertTrue(tutorials.finishCalled)
    }

    func test_it_returns_current_tutorial_when_it_appears() {
        Tutorial.allCases.forEach { tutorial in
            let tutorials = TutorialsStub(current: tutorial)
            let sut = TutorialViewModelImpl(tutorials: tutorials)

            sut.onEvent(.lifecycle(.appear))

            XCTAssertEqual(sut.tutorial, tutorial)
        }
    }
}

class TutorialsSpy: Tutorials {

    var finishCalled = false

    init() {}

    func getCurrent() -> Tutorial? { return nil }

    func finish() {
        finishCalled = true
    }

    func checkTutorials(for event: TutorialTriggeringEvent) { }
}

class TutorialsStub: Tutorials {

    let current: Tutorial

    init(current: Tutorial) {
        self.current = current
    }

    func getCurrent() -> Tutorial? { current }
    func finish() { }
    func checkTutorials(for event: TutorialTriggeringEvent) { }
}
