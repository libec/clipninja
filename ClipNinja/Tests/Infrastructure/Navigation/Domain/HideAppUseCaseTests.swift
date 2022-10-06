import XCTest
@testable import ClipNinja

class HideAppUseCaseTests: XCTestCase {

    func test_it_uses_navigation_to_hide_the_app() throws {
        let navigation = NavigationSpy()
        let sut = HideAppUseCaseImpl(navigation: navigation)

        sut.hide()

        XCTAssertTrue(try XCTUnwrap(navigation.hideCalled))
    }
}

class NavigationSpy: Navigation {

    var hideCalled: Bool?

    func hide() {
        hideCalled = true
    }

    func subscribe() {

    }
}
