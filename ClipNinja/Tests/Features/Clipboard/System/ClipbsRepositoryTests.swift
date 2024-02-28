@testable import ClipNinjaPackage
import Combine
import XCTest

final class ClipsRepositoryTests: XCTestCase {
    var sut: ClipsRepository!

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func test_it_deletes_clip_at_index() {
        let clips: [Clip] = [
            .init(text: "foo", pinned: true),
            .init(text: "3841", pinned: true),
            .init(text: "import AppKit", pinned: false),
        ]
        let clipsResource = ClipsResourceStub(clips: clips)
        setupSut(clipsResource: clipsResource)

        sut.delete(at: 2)

        let expectedClips: [Clip] = [
            .init(text: "foo", pinned: true),
            .init(text: "3841", pinned: true),
        ]
        XCTAssertEqual(sut.lastClips, expectedClips)
    }

    func test_it_checks_clips_indices_before_removing_clip() {
        let clips: [Clip] = [
            .init(text: "foo", pinned: true),
        ]
        let clipsResource = ClipsResourceStub(clips: clips)
        setupSut(clipsResource: clipsResource)

        sut.delete(at: 2)

        let expectedClips: [Clip] = [
            .init(text: "foo", pinned: true),
        ]
        XCTAssertEqual(sut.lastClips, expectedClips)
    }

    func test_it_toggles_unpinned_clip_last_place_after_pinned_clips() {
        let clips: [Clip] = [
            .init(text: "foo", pinned: true),
            .init(text: "3841", pinned: false),
            .init(text: "import AppKit", pinned: false),
        ]
        let clipsResource = ClipsResourceStub(clips: clips)
        setupSut(clipsResource: clipsResource)

        sut.togglePin(at: 2)

        let expectedClips: [Clip] = [
            .init(text: "foo", pinned: true),
            .init(text: "import AppKit", pinned: true),
            .init(text: "3841", pinned: false),
        ]
        XCTAssertEqual(sut.lastClips, expectedClips)
    }

    func test_it_toggles_pinned_clip_to_last_place_after_pinned_clips() {
        let clips: [Clip] = [
            .init(text: "foo", pinned: true),
            .init(text: "bar_a31934", pinned: true),
            .init(text: "3841", pinned: true),
            .init(text: "import AppKit", pinned: false),
        ]
        let clipsResource = ClipsResourceStub(clips: clips)
        setupSut(clipsResource: clipsResource)

        sut.togglePin(at: 0)

        let expectedClips: [Clip] = [
            .init(text: "bar_a31934", pinned: true),
            .init(text: "3841", pinned: true),
            .init(text: "foo", pinned: false),
            .init(text: "import AppKit", pinned: false),
        ]
        XCTAssertEqual(sut.lastClips, expectedClips)
    }

    func test_it_ignores_toggling_clip_out_of_bounds() {
        let clips: [Clip] = [
            .init(text: "foo", pinned: true),
        ]
        let clipsResource = ClipsResourceStub(clips: clips)
        setupSut(clipsResource: clipsResource)

        sut.togglePin(at: 1)

        let expectedClips: [Clip] = [
            .init(text: "foo", pinned: true),
        ]
        XCTAssertEqual(sut.lastClips, expectedClips)
    }

    func test_it_moves_selected_pin_after_pinned_clips() {
        let clips: [Clip] = [
            .init(text: "foo", pinned: true),
            .init(text: "bar_a31934", pinned: false),
            .init(text: "3841", pinned: false),
            .init(text: "import AppKit", pinned: false),
        ]
        let clipsResource = ClipsResourceStub(clips: clips)
        setupSut(clipsResource: clipsResource)

        sut.moveAfterPins(index: 3)

        let expectedClips: [Clip] = [
            .init(text: "foo", pinned: true),
            .init(text: "import AppKit", pinned: false),
            .init(text: "bar_a31934", pinned: false),
            .init(text: "3841", pinned: false),
        ]
        XCTAssertEqual(sut.lastClips, expectedClips)
    }

    func test_it_ignores_moving_clip_out_of_bounds() {
        let clips: [Clip] = [
            .init(text: "foo", pinned: true),
            .init(text: "bar_a31934", pinned: false),
        ]
        let clipsResource = ClipsResourceStub(clips: clips)
        setupSut(clipsResource: clipsResource)

        sut.moveAfterPins(index: 2)

        let expectedClips: [Clip] = [
            .init(text: "foo", pinned: true),
            .init(text: "bar_a31934", pinned: false),
        ]
        XCTAssertEqual(sut.lastClips, expectedClips)
    }

    private func setupSut(
        pasteboardObserver: PasteboardObserver = PasteboardObserverDummy(),
        clipsResource: ClipsResource = ClipsResourceDummy(),
        viewPortConfiguration: ViewPortConfiguration = TestViewPortConfiguration(),
        settingsRepository: SettingsRepository = SettingsRepositoryDummy()
    ) {
        sut = ClipsRepositoryImpl(
            pasteboardObserver: pasteboardObserver,
            clipsResource: clipsResource,
            viewPortConfiguration: viewPortConfiguration,
            storageScheduler: ImmediateScheduler.shared,
            settingsRepository: settingsRepository
        )
    }
}
