import XCTest
@testable import ClipNinja

class HideAppUseCaseTests: XCTestCase {

    func test_it_uses_navigation_to_hide_the_app() throws {
        let navigation = NavigationSpy()
        let sut = HideAppUseCaseImpl(
            navigation: navigation,
            viewPortRepository: InMemoryViewPortRepository()
        )

        sut.hide()

        try XCTAssertTrue(XCTUnwrap(navigation.hideCalled))
    }

    func test_hiding_app_moves_view_port_to_beginning() {
        let viewPortRepository = InMemoryViewPortRepository()
        viewPortRepository.update(position: 5)
        let sut = HideAppUseCaseImpl(
            navigation: NavigationDummy(),
            viewPortRepository: viewPortRepository
        )

        sut.hide()

        XCTAssertEqual(viewPortRepository.lastPosition, 0)
    }
}

typealias NavigationDummy = NavigationSpy
class NavigationSpy: Navigation {

    var hideCalled: Bool?

    func hide() {
        hideCalled = true
    }

    func subscribe() {

    }
}
