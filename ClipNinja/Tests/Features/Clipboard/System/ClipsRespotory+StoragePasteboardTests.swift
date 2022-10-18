import Combine
@testable import ClipNinja
import XCTest

final class ClipsRespotoryStorageAndPasteboardTests: XCTestCase {
    var sut: ClipsRepository!

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func test_it_loads_clips_from_storage_on_init() {
        let clipStrings = ["a236x", "clipninja", "repostitoaer"]
        let initialClips: [Clip] = clipStrings.map { Clip(text: $0, pinned: false) }
        let clipsStorage = ClipsStorageStub(clips: initialClips)

        setupSut(clipsStorage: clipsStorage)

        XCTAssertEqual(sut.lastClips, initialClips)
    }

    func test_it_stores_clips_when_they_change() {
        let clipsStorage = ClipsStorageSpy()
        let pasteboardObserver = PasteboardObserverStub()
        setupSut(pasteboardObserver: pasteboardObserver, clipsStorage: clipsStorage)

        pasteboardObserver.subject.send("Foo")
        pasteboardObserver.subject.send("Bar")
        pasteboardObserver.subject.send("foobar")

        let expectedClips: [Clip] = [
            .init(text: "foobar", pinned: false),
            .init(text: "Bar", pinned: false),
            .init(text: "Foo", pinned: false),
        ]
        try XCTAssertEqual(XCTUnwrap(clipsStorage.persistedClips), expectedClips)
    }

    func test_it_stores_new_clips_from_pasteboard_to_top() {
        let clips: [Clip] = [
            .init(text: "foo", pinned: false),
        ]
        let clipsStorage = ClipsStorageStub(clips: clips)
        let pasteboardObserver = PasteboardObserverStub()
        setupSut(pasteboardObserver: pasteboardObserver, clipsStorage: clipsStorage)

        pasteboardObserver.subject.send("atom,slack,bear")
        pasteboardObserver.subject.send("import foobar")
        pasteboardObserver.subject.send("heyclipninja")

        let expectedClips: [Clip] = [
            .init(text: "heyclipninja", pinned: false),
            .init(text: "import foobar", pinned: false),
            .init(text: "atom,slack,bear", pinned: false),
            .init(text: "foo", pinned: false),
        ]
        XCTAssertEqual(sut.lastClips, expectedClips)
    }

    func test_it_ignores_duplicated_clips_that_are_pinned() {
        let clips: [Clip] = [
            .init(text: "foo", pinned: true),
            .init(text: "heyclipninja", pinned: true),
            .init(text: "waerfawef", pinned: false),
        ]
        let clipsStorage = ClipsStorageStub(clips: clips)
        let pasteboardObserver = PasteboardObserverStub()
        setupSut(pasteboardObserver: pasteboardObserver, clipsStorage: clipsStorage)

        pasteboardObserver.subject.send("foo")
        pasteboardObserver.subject.send("heyclipninja")

        try XCTAssertEqual(XCTUnwrap(clipsStorage.persistedClips), clips)
    }

    func test_it_moves_duplicated_unpinned_clips_after_pins() {
        let clips: [Clip] = [
            .init(text: "foo", pinned: true),
            .init(text: "3841", pinned: true),
            .init(text: "import AppKit", pinned: false),
            .init(text: "waerfawef", pinned: false),
            .init(text: "heyclipninja", pinned: false),
        ]
        let clipsStorage = ClipsStorageStub(clips: clips)
        let pasteboardObserver = PasteboardObserverStub()
        setupSut(pasteboardObserver: pasteboardObserver, clipsStorage: clipsStorage)

        pasteboardObserver.subject.send("heyclipninja")

        let expectedClips: [Clip] = [
            .init(text: "foo", pinned: true),
            .init(text: "3841", pinned: true),
            .init(text: "heyclipninja", pinned: false),
            .init(text: "import AppKit", pinned: false),
            .init(text: "waerfawef", pinned: false),
        ]
        try XCTAssertEqual(XCTUnwrap(clipsStorage.persistedClips), expectedClips)
    }

    func test_it_trims_max_clips() {
        let clips: [Clip] = [
            .init(text: "foo", pinned: true),
            .init(text: "3841", pinned: true),
            .init(text: "import AppKit", pinned: false),
            .init(text: "waerfawef", pinned: false),
            .init(text: "clipninja", pinned: false),
            .init(text: "__1231__", pinned: false),
        ]
        let clipsStorage = ClipsStorageStub(clips: clips)
        let pasteboardObserver = PasteboardObserverStub()
        setupSut(
            pasteboardObserver: pasteboardObserver,
            clipsStorage: clipsStorage,
            viewPortConfiguration: ViewPortConfigurationStub(
                totalPages: 2,
                clipsPerPage: 3
            )
        )

        pasteboardObserver.subject.send("heyclipninja")

        let expectedClips: [Clip] = [
            .init(text: "foo", pinned: true),
            .init(text: "3841", pinned: true),
            .init(text: "heyclipninja", pinned: false),
            .init(text: "import AppKit", pinned: false),
            .init(text: "waerfawef", pinned: false),
            .init(text: "clipninja", pinned: false),
        ]
        try XCTAssertEqual(XCTUnwrap(clipsStorage.persistedClips), expectedClips)
    }

    private func setupSut(
        pasteboardObserver: PasteboardObserver = PasteboardObserverDummy(),
        clipsStorage: ClipsStorage = ClipsStorageDummy(),
        viewPortConfiguration: ViewPortConfiguration = TestViewPortConfiguration()
    ) {
        self.sut = ClipsRepositoryImpl(
            pasteboardObserver: pasteboardObserver,
            clipsStorage: clipsStorage,
            viewPortConfiguration: viewPortConfiguration
        )
    }
}
