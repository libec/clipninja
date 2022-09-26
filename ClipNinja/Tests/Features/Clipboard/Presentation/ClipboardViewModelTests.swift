import Combine
@testable import ClipNinja
import XCTest

class ClipboardViewModelTests: XCTestCase {
    
    func test_it_passes_events_to_domain_to_handle() throws {
        let clipboards = ClipboardsSpy()
        let factory = ClipboardPreviewFactoryDummy()
        let sut = ClipboardViewModelImpl(
            clipboards: clipboards,
            previewFactory: factory
        )

        sut.onEvent(.up)
        XCTAssertEqual(clipboards.movedToViewPort, .up)

        sut.onEvent(.down)
        XCTAssertEqual(clipboards.movedToViewPort, .down)

        sut.onEvent(.left)
        XCTAssertEqual(clipboards.movedToViewPort, .left)

        sut.onEvent(.right)
        XCTAssertEqual(clipboards.movedToViewPort, .right)

        sut.onEvent(.enter)
        XCTAssertEqual(try XCTUnwrap(clipboards.pastedAtIndex), .selected)

        sut.onEvent(.number(number: 7))
        XCTAssertEqual(try XCTUnwrap(clipboards.pastedAtIndex), .index(7))

        sut.onEvent(.delete)
        XCTAssertTrue(clipboards.deleteCalled)

        sut.onEvent(.space)
        XCTAssertTrue(clipboards.pinCalled)
    }

    func test_it_updates_view_with_formatted_clip_previews() throws {
        let clips = try loadFromJson(type: [Clip].self, path: "clips")
        let clipsPreviews = try loadFromJson(type: [ClipPreview].self, path: "clipsPreview")
        let clipboards = ClipboardsStub()
        let factory = ClipboardPreviewFactoryImpl()
        var subscriptions = Set<AnyCancellable>()

        let sut = ClipboardViewModelImpl(
            clipboards: clipboards,
            previewFactory: factory
        )

        sut.subscribe()

        clipboards.subject.send(
            ClipboardViewPort(
                clips: clips,
                selectedTab: 3,
                numberOfTabs: 7
            )
        )

        sut.$clipPreviews.sink { value in
            XCTAssertEqual(value, clipsPreviews)
        }.store(in: &subscriptions)

        sut.$totalTabs.sink { tabs in
            XCTAssertEqual(tabs, 7)
        }.store(in: &subscriptions)

        sut.$shownTab.sink { tabs in
            XCTAssertEqual(tabs, 3)
        }.store(in: &subscriptions)
    }
}

class ClipboardsSpy: Clipboards {

    var pinCalled = false
    var deleteCalled = false
    var pastedAtIndex: PasteIndex? = nil
    var movedToViewPort: ViewPortMovement? = nil

    var clips: AnyPublisher<ClipboardViewPort, Never> {
        Empty().eraseToAnyPublisher()
    }

    func pin() {
        pinCalled = true
    }

    func delete() {
        deleteCalled = true
    }

    func paste(at index: PasteIndex) {
        pastedAtIndex = index
    }

    func move(to viewPort: ViewPortMovement) {
        movedToViewPort = viewPort
    }
}

class ClipboardsStub: ClipboardsSpy {

    let subject = PassthroughSubject<ClipboardViewPort, Never>()

    override var clips: AnyPublisher<ClipboardViewPort, Never> {
        subject.eraseToAnyPublisher()
    }
}

class ClipboardPreviewFactoryDummy: ClipboardPreviewFactory {

    func makePreview(from clip: Clip, index: Int) -> ClipPreview {
        return .dummy
    }
}

extension ClipPreview {

    static var dummy: ClipPreview {
        ClipPreview(
            previewText: "foo",
            selected: false,
            pinned: false,
            shortcutNumber: "0"
        )
    }
}
