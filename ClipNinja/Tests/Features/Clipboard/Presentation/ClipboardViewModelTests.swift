import Combine
@testable import ClipNinjaPackage
import XCTest

class ClipboardViewModelTests: XCTestCase {
    
    func test_it_passes_events_to_domain_to_handle() throws {
        let clipboards = ClipboardsSpy()
        let factory = ClipboardPreviewFactoryDummy()
        let sut = ClipboardViewModelImpl(
            clipboards: clipboards,
            previewFactory: factory,
            hideAppUseCase: HideAppUseCaseDummy(),
            viewPortConfiguration: TestViewPortConfiguration(),
            checkTutorialUseCase: CheckTutorialUseCaseDummy()
        )

        sut.onEvent(.keyboard(.up))
        XCTAssertEqual(clipboards.movedToViewPort, .up)

        sut.onEvent(.keyboard(.down))
        XCTAssertEqual(clipboards.movedToViewPort, .down)

        sut.onEvent(.keyboard(.left))
        XCTAssertEqual(clipboards.movedToViewPort, .left)

        sut.onEvent(.keyboard(.right))
        XCTAssertEqual(clipboards.movedToViewPort, .right)

        sut.onEvent(.keyboard(.enter))
        try XCTAssertEqual(XCTUnwrap(clipboards.pastedAtIndex), .selected)

        sut.onEvent(.keyboard(.number(number: 7)))
        try XCTAssertEqual(XCTUnwrap(clipboards.pastedAtIndex), .index(6))

        sut.onEvent(.keyboard(.delete))
        XCTAssertTrue(clipboards.deleteCalled)

        sut.onEvent(.keyboard(.space))
        XCTAssertTrue(clipboards.pinCalled)
    }

    func test_it_adjusts_pressed_number_to_index() {
        let clipboards = ClipboardsSpy()
        let factory = ClipboardPreviewFactoryDummy()
        let sut = ClipboardViewModelImpl(
            clipboards: clipboards,
            previewFactory: factory,
            hideAppUseCase: HideAppUseCaseDummy(),
            viewPortConfiguration: TestViewPortConfiguration(),
            checkTutorialUseCase: CheckTutorialUseCaseDummy()
        )
        
        sut.onEvent(.keyboard(.number(number: 7)))
        try XCTAssertEqual(XCTUnwrap(clipboards.pastedAtIndex), .index(6))

        sut.onEvent(.keyboard(.number(number: 2)))
        try XCTAssertEqual(XCTUnwrap(clipboards.pastedAtIndex), .index(1))
    }

    func test_it_updates_view_with_formatted_clip_previews() throws {
        let clipTexts = ["foo", "bar", "extension Array {\n\nfunc mapWithIndex<T> (f: (Int, Element) -> T) -> [T] {\nreturn zip((self.startIndex ..< self.endIndex), self).map(f)\n}\n}"]
        let clips: [Clip] = clipTexts.map { Clip(text: $0, pinned: false) }

        let clipPreviewTexts = ["foo", "bar", "extension Array {"]
        let clipsPreviews: [ClipPreview] = clipPreviewTexts.enumerated().map { index, element in
            ClipPreview(previewText: element, selected: index == 0, pinned: false, shortcutNumber: "\(index + 1)")
        }
        let clipboards = ClipboardsStub()
        let factory = ClipboardPreviewFactoryImpl()

        let sut = ClipboardViewModelImpl(
            clipboards: clipboards,
            previewFactory: factory,
            hideAppUseCase: HideAppUseCaseDummy(),
            viewPortConfiguration: TestViewPortConfiguration(),
            checkTutorialUseCase: CheckTutorialUseCaseDummy()
        )

        sut.onEvent(.lifecycle(.appear))

        clipboards.subject.send(
            ClipboardViewPort(
                clips: clips,
                selectedClipIndex: 0,
                selectedPage: 3,
                numberOfPages: 7
            )
        )

        XCTAssertEqual(sut.clipPreviews, clipsPreviews)
        XCTAssertEqual(sut.totalPages, 7)
        XCTAssertEqual(sut.shownPage, 3)
    }

    func test_is_hides_app_on_escape_event() throws {
        let hideAppUseCase = HideAppUseCaseSpy()
        let sut = ClipboardViewModelImpl(
            clipboards: ClipboardsDummy(),
            previewFactory: ClipboardPreviewFactoryDummy(),
            hideAppUseCase: hideAppUseCase,
            viewPortConfiguration: TestViewPortConfiguration(),
            checkTutorialUseCase: CheckTutorialUseCaseDummy()
        )

        sut.onEvent(.keyboard(.escape))

        XCTAssertTrue(try XCTUnwrap(hideAppUseCase.hideCalled))
    }

    func test_it_checks_for_tutorials_when_appearing() {
        let checkTutorialUseCase = CheckTutorialUseCaseSpy()
        let sut = ClipboardViewModelImpl(
            clipboards: ClipboardsDummy(),
            previewFactory: ClipboardPreviewFactoryDummy(),
            hideAppUseCase: HideAppUseCaseDummy(),
            viewPortConfiguration: TestViewPortConfiguration(),
            checkTutorialUseCase: checkTutorialUseCase
        )

        sut.onEvent(.lifecycle(.appear))

        XCTAssertEqual(checkTutorialUseCase.checkedEvent, .clipsAppear)
    }
}

class ClipboardPreviewFactoryDummy: ClipboardPreviewFactory {

    func makePreview(from clip: Clip, index: Int, selected: Bool) -> ClipPreview {
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

typealias CheckTutorialUseCaseDummy = CheckTutorialUseCaseSpy
class CheckTutorialUseCaseSpy: CheckTutorialUseCase {
    var checkedEvent: TutorialTriggeringEvent?
    func checkTutorials(for event: TutorialTriggeringEvent) {
        checkedEvent = event
    }
}
