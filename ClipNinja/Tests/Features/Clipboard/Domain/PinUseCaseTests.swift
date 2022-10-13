@testable import ClipNinja
import XCTest

class PinUseCaseTests: XCTestCase {

    func test_it_uses_view_port_to_update_clips() throws {
        let clipsRepository = ClipsRepositoryAmountStub(numberOfClips: 5)
        let viewPortRepository = InMemoryViewPortRepository()
        viewPortRepository.update(position: 2)
        let sut = PinUseCaseImpl(
            clipsRepository: clipsRepository,
            viewPortRepository: viewPortRepository
        )

        sut.pin()

        try XCTAssertEqual(XCTUnwrap(clipsRepository.toggledPin), 2)
    }

    func test_it_changes_view_port_to_newly_pinned_clip() {
        let clipsRepository = ClipsRepositoryStub(lastClips: [
            Clip(text: "awefwa", pinned: true),
            Clip(text: "a3d31", pinned: true),
            Clip(text: "foo_bar_a3d31", pinned: true),
            Clip(text: "478zsda", pinned: false),
            Clip(text: "fooasdfsdfb_a3d31", pinned: false),
        ])
        let viewPortRepository = InMemoryViewPortRepository()
        viewPortRepository.update(position: 4)

        let sut = PinUseCaseImpl(
            clipsRepository: clipsRepository,
            viewPortRepository: viewPortRepository
        )

        sut.pin()

        XCTAssertEqual(viewPortRepository.lastPosition, 3)
    }

    func test_it_changes_view_port_to_newly_unpinned_clip() {
        let clipsRepository = ClipsRepositoryStub(lastClips: [
            Clip(text: "awefwa", pinned: true),
            Clip(text: "a3d31", pinned: true),
            Clip(text: "foo_bar_a3d31", pinned: true),
            Clip(text: "478zsda", pinned: false),
            Clip(text: "fooasdfsdfb_a3d31", pinned: false),
        ])
        let viewPortRepository = InMemoryViewPortRepository()
        viewPortRepository.update(position: 0)

        let sut = PinUseCaseImpl(
            clipsRepository: clipsRepository,
            viewPortRepository: viewPortRepository
        )

        sut.pin()

        XCTAssertEqual(viewPortRepository.lastPosition, 2)
    }

    func test_it_checks_if_viewport_fits_into_clips_array() {
        let clipsRepository = ClipsRepositoryStub(lastClips: [
            Clip(text: "awefwa", pinned: true),
            Clip(text: "a3d31", pinned: true),
        ])
        let viewPortRepository = InMemoryViewPortRepository()
        viewPortRepository.update(position: 6)

        let sut = PinUseCaseImpl(
            clipsRepository: clipsRepository,
            viewPortRepository: viewPortRepository
        )

        sut.pin()

        XCTAssertNil(clipsRepository.toggledPin)
    }
}
