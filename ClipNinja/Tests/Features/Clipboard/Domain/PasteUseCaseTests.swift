import XCTest
@testable import ClipNinja
import Combine

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

        try XCTAssertTrue(XCTUnwrap(hideAppUseCase.hideCalled))
    }

    func test_it_pastes_selected_clip() {
        let pasteTextUseCase = PasteTextUseCaseSpy()
        let viewPortRepository = InMemoryViewPortRepository()
        viewPortRepository.update(position: 2)
        let selectedClipToPaste = Clip(text: "eaf31z", pinned: false)
        let sut = makeSut(
            pasteTextUseCase: pasteTextUseCase,
            clipsRepository: ClipsRepositoryStub(lastClips: [
                Clip(text: "aewf2", pinned: true),
                Clip(text: "aeaefwf2", pinned: true),
                selectedClipToPaste,
                Clip(text: "wa24", pinned: true),
            ]),
            viewPortRepository: viewPortRepository
        )

        sut.paste(at: .selected)

        XCTAssertEqual(selectedClipToPaste.text, pasteTextUseCase.pastedText)
    }

    func test_it_moves_pasted_clip_after_pins() {
        let viewPortRepository = InMemoryViewPortRepository()
        viewPortRepository.update(position: 2)
        let selectedClipToPaste = Clip(text: "eaf31z", pinned: false)
        let clipsRepository = ClipsRepositoryStub(lastClips: [
            Clip(text: "aewf2", pinned: true),
            Clip(text: "aeaefwf2", pinned: false),
            selectedClipToPaste,
            Clip(text: "wa24", pinned: false),
        ])
        let sut = makeSut(
            clipsRepository: clipsRepository,
            viewPortRepository: viewPortRepository
        )

        sut.paste(at: .selected)

        try XCTAssertEqual(XCTUnwrap(clipsRepository.movedAfterPinsAtIndex), 2)
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
                Clip(text: "aewf2", pinned: true),
                Clip(text: "aeaefwf2", pinned: true),
                Clip(text: "wa24", pinned: true),
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
        let selectedClipToPaste = Clip(text: "fa_ea31", pinned: false)
        let sut = makeSut(
            pasteTextUseCase: pasteTextUseCase,
            clipsRepository: ClipsRepositoryStub(lastClips: [
                Clip(text: "aewf2", pinned: true),
                Clip(text: "aeaefwf2", pinned: true),
                Clip(text: "wa24", pinned: true),
                Clip(text: "secre_te2view", pinned: true),
                selectedClipToPaste,
            ]),
            viewPortRepository: viewPortRepository
        )

        sut.paste(at: .index(4))

        XCTAssertEqual(selectedClipToPaste.text, pasteTextUseCase.pastedText)
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
                Clip(text: "aewf2", pinned: true),
                Clip(text: "aeaefwf2", pinned: true),
                Clip(text: "wa24", pinned: true),
                Clip(text: "secre_te2view", pinned: true),
            ]),
            viewPortRepository: viewPortRepository
        )

        sut.paste(at: .index(8))

        XCTAssertNil(pasteTextUseCase.pastedText)
        XCTAssertNil(hideAppUseCase.hideCalled)
    }

    func test_it_moves_clips_then_hides_and_then_pastes() {
        let viewPortRepository = InMemoryViewPortRepository()
        viewPortRepository.update(position: 0)
        let pasteOrderSpy = PasteOrderSpy(
            clips: [
                Clip(text: "aewf2", pinned: false),
                Clip(text: "aeaefwf2", pinned: false)
            ]
        )
        let sut = makeSut(
            hideAppUseCase: pasteOrderSpy,
            pasteTextUseCase: pasteOrderSpy,
            clipsRepository: pasteOrderSpy,
            viewPortRepository: viewPortRepository
        )

        sut.paste(at: .selected)

        XCTAssertEqual(pasteOrderSpy.steps, [.moveAfterPins, .hideApp, .paste])
    }

    func test_it_doesnt_move_pinned_clip() {
        let viewPortRepository = InMemoryViewPortRepository()
        viewPortRepository.update(position: 0)
        let clipsRepository = ClipsRepositoryStub(lastClips: [
            Clip(text: "aewf2", pinned: true),
            Clip(text: "aeaefwf2", pinned: true),
            Clip(text: "wa24", pinned: false),
        ])
        let sut = makeSut(
            clipsRepository: clipsRepository,
            viewPortRepository: viewPortRepository
        )

        sut.paste(at: .selected)

        XCTAssertNil(clipsRepository.movedAfterPinsAtIndex)
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
