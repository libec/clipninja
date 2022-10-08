import XCTest
@testable import ClipNinja

class PasteUseCaseTests: XCTestCase {
    func test_it_hides_the_app_before_pasting() throws {
        let hideAppUseCase = HideAppUseCaseSpy()
        let viewPortRepository = InMemoryViewPortRepository()
        viewPortRepository.update(position: 2)
        let sut = makeSut(
            hideAppUseCase: hideAppUseCase,
            clipsRepository: ClipsRepositoryAmountStub(numberOfClips: 5),
            viewPortRepository: viewPortRepository
        )

        sut.paste(at: .selected)

        XCTAssertTrue(try XCTUnwrap(hideAppUseCase.hideCalled))
    }

    func test_it_pastes_selected_clip() {
        let pasteTextUseCase = PasteTextUseCaseSpy()
        let viewPortRepository = InMemoryViewPortRepository()
        viewPortRepository.update(position: 2)
        let selectedClipboardRecordToPaste = ClipboardRecord(text: "eaf31z", pinned: false)
        let sut = makeSut(
            pasteTextUseCase: pasteTextUseCase,
            clipsRepository: ClipsRepositoryStub(lastClips: [
                ClipboardRecord(text: "aewf2", pinned: true),
                ClipboardRecord(text: "aeaefwf2", pinned: true),
                selectedClipboardRecordToPaste,
                ClipboardRecord(text: "wa24", pinned: true),
            ]),
            viewPortRepository: viewPortRepository
        )

        sut.paste(at: .selected)

        XCTAssertEqual(selectedClipboardRecordToPaste.text, pasteTextUseCase.pastedText)
    }

    func test_it_doesnt_paste_or_hide_when_selected_doesnt_exist() {
        let pasteTextUseCase = PasteTextUseCaseSpy()
        let hideAppUseCase = HideAppUseCaseSpy()
        let viewPortRepository = InMemoryViewPortRepository()
        viewPortRepository.update(position: 12)
        let sut = makeSut(
            hideAppUseCase: hideAppUseCase,
            pasteTextUseCase: pasteTextUseCase,
            clipsRepository: ClipsRepositoryStub(lastClips: [
                ClipboardRecord(text: "aewf2", pinned: true),
                ClipboardRecord(text: "aeaefwf2", pinned: true),
                ClipboardRecord(text: "wa24", pinned: true),
            ]),
            viewPortRepository: viewPortRepository
        )

        sut.paste(at: .selected)

        XCTAssertNil(pasteTextUseCase.pastedText)
        XCTAssertNil(hideAppUseCase.hideCalled)
    }

    func test_it_pastes_clip_at_index_ignoring_view_port_position() {
        let pasteTextUseCase = PasteTextUseCaseSpy()
        let viewPortRepository = InMemoryViewPortRepository()
        viewPortRepository.update(position: 0)
        let selectedClipboardRecordToPaste = ClipboardRecord(text: "fa_ea31", pinned: false)
        let sut = makeSut(
            pasteTextUseCase: pasteTextUseCase,
            clipsRepository: ClipsRepositoryStub(lastClips: [
                ClipboardRecord(text: "aewf2", pinned: true),
                ClipboardRecord(text: "aeaefwf2", pinned: true),
                ClipboardRecord(text: "wa24", pinned: true),
                ClipboardRecord(text: "secre_te2view", pinned: true),
                selectedClipboardRecordToPaste,
            ]),
            viewPortRepository: viewPortRepository
        )

        sut.paste(at: .index(4))

        XCTAssertEqual(selectedClipboardRecordToPaste.text, pasteTextUseCase.pastedText)
    }

    func test_it_doesnt_paste_or_hide_when_index_doesnt_exist() {
        let pasteTextUseCase = PasteTextUseCaseSpy()
        let hideAppUseCase = HideAppUseCaseSpy()
        let viewPortRepository = InMemoryViewPortRepository()
        viewPortRepository.update(position: 0)
        let sut = makeSut(
            hideAppUseCase: hideAppUseCase,
            pasteTextUseCase: pasteTextUseCase,
            clipsRepository: ClipsRepositoryStub(lastClips: [
                ClipboardRecord(text: "aewf2", pinned: true),
                ClipboardRecord(text: "aeaefwf2", pinned: true),
                ClipboardRecord(text: "wa24", pinned: true),
                ClipboardRecord(text: "secre_te2view", pinned: true),
            ]),
            viewPortRepository: viewPortRepository
        )

        sut.paste(at: .index(8))

        XCTAssertNil(pasteTextUseCase.pastedText)
        XCTAssertNil(hideAppUseCase.hideCalled)
    }

    private func makeSut(
        hideAppUseCase: HideAppUseCase = HideAppUseCaseDummy(),
        pasteTextUseCase: PasteTextUseCase = PasteTextUseCaseDummy(),
        clipsRepository: ClipsRepository,
        viewPortRepository: ViewPortRepository
    ) -> PasteUseCase {
        return PasteUseCaseImpl(
            clipsRepository: clipsRepository,
            viewPortRepository: viewPortRepository,
            hideAppUseCase: hideAppUseCase,
            pasteTextUseCase: pasteTextUseCase,
            viewPortConfiguration: TestViewPortConfiguration()
        )
    }
}
