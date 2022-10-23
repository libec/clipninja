import Combine
import XCTest
@testable import ClipNinjaPackage

class HideAppUseCaseTests: XCTestCase {

    func test_it_uses_navigation_to_hide_the_app() throws {
        let navigation = NavigationSpy()
        let sut = HideAppUseCaseImpl(
            navigation: navigation,
            viewPortRepository: InMemoryViewPortRepository()
        )

        sut.hide()

        try XCTAssertEqual(XCTUnwrap(navigation.handledEvent), .hideApp)
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

    var handledEvent: NavigationEvent?

    var navigationEvent: AnyPublisher<NavigationEvent, Never> {
        fatalError()
    }

    func handle(navigationEvent: NavigationEvent) {
        self.handledEvent = navigationEvent
    }
}
