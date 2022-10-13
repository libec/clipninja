import Combine
@testable import ClipNinja
import XCTest

class ClipboardViewModelTests: XCTestCase {
    
    func test_it_passes_events_to_domain_to_handle() throws {
        let clipboards = ClipboardsSpy()
        let factory = ClipboardPreviewFactoryDummy()
        let sut = ClipboardViewModelImpl(
            clipboards: clipboards,
            previewFactory: factory,
            hideAppUseCase: HideAppUseCaseDummy(),
            viewPortConfiguration: TestViewPortConfiguration()
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
        try XCTAssertEqual(XCTUnwrap(clipboards.pastedAtIndex), .selected)

        sut.onEvent(.number(number: 7))
        try XCTAssertEqual(XCTUnwrap(clipboards.pastedAtIndex), .index(6))

        sut.onEvent(.delete)
        XCTAssertTrue(clipboards.deleteCalled)

        sut.onEvent(.space)
        XCTAssertTrue(clipboards.pinCalled)
    }

    func test_it_adjusts_pressed_number_to_index() {
        let clipboards = ClipboardsSpy()
        let factory = ClipboardPreviewFactoryDummy()
        let sut = ClipboardViewModelImpl(
            clipboards: clipboards,
            previewFactory: factory,
            hideAppUseCase: HideAppUseCaseDummy(),
            viewPortConfiguration: TestViewPortConfiguration()
        )
        
        sut.onEvent(.number(number: 7))
        try XCTAssertEqual(XCTUnwrap(clipboards.pastedAtIndex), .index(6))

        sut.onEvent(.number(number: 2))
        try XCTAssertEqual(XCTUnwrap(clipboards.pastedAtIndex), .index(1))
    }

    func test_it_updates_view_with_formatted_clip_previews() throws {
        let clipTexts = ["foo", "bar", "extension Array {\n\nfunc mapWithIndex<T> (f: (Int, Element) -> T) -> [T] {\nreturn zip((self.startIndex ..< self.endIndex), self).map(f)\n}\n}"]
        let clips: [Clip] = clipTexts.map { Clip(text: $0, pinned: false, selected: false) }

        let clipPreviewTexts = ["foo", "bar", "extension Array {"]
        let clipsPreviews: [ClipPreview] = clipPreviewTexts.enumerated().map { index, element in
            ClipPreview(previewText: element, selected: false, pinned: false, shortcutNumber: "\(index + 1)")
        }
        let clipboards = ClipboardsStub()
        let factory = ClipboardPreviewFactoryImpl()
        var subscriptions = Set<AnyCancellable>()

        let sut = ClipboardViewModelImpl(
            clipboards: clipboards,
            previewFactory: factory,
            hideAppUseCase: HideAppUseCaseDummy(),
            viewPortConfiguration: TestViewPortConfiguration()
        )

        sut.subscribe()

        clipboards.subject.send(
            ClipboardViewPort(
                clips: clips,
                selectedPage: 3,
                numberOfPages: 7
            )
        )

        sut.$clipPreviews.sink { value in
            XCTAssertEqual(value, clipsPreviews)
        }.store(in: &subscriptions)

        sut.$totalPages.sink { tabs in
            XCTAssertEqual(tabs, 7)
        }.store(in: &subscriptions)

        sut.$shownPage.sink { tabs in
            XCTAssertEqual(tabs, 3)
        }.store(in: &subscriptions)
    }

    func test_is_hides_app_on_escape_event() throws {
        let hideAppUseCase = HideAppUseCaseSpy()
        let sut = ClipboardViewModelImpl(
            clipboards: ClipboardsDummy(),
            previewFactory: ClipboardPreviewFactoryDummy(),
            hideAppUseCase: hideAppUseCase,
            viewPortConfiguration: TestViewPortConfiguration()
        )

        sut.onEvent(ClipboardViewModelEvent.escape)

        XCTAssertTrue(try XCTUnwrap(hideAppUseCase.hideCalled))
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
