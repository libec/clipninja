protocol PasteUseCase {
    func paste(at index: PasteIndex)
}

enum PasteIndex: Equatable {
    case selected
    case index(_ index: Int)
}

final class PasteUseCaseImpl: PasteUseCase {

    private let clipsRepository: ClipsRepository
    private let viewPortRepository: ViewPortRepository
    private let hideAppUseCase: HideAppUseCase
    private let pasteTextUseCase: PasteTextUseCase
    private let viewPortConfiguration: ViewPortConfiguration

    init(
        clipsRepository: ClipsRepository,
        viewPortRepository: ViewPortRepository,
        hideAppUseCase: HideAppUseCase,
        pasteTextUseCase: PasteTextUseCase,
        viewPortConfiguration: ViewPortConfiguration
    ) {
        self.clipsRepository = clipsRepository
        self.viewPortRepository = viewPortRepository
        self.hideAppUseCase = hideAppUseCase
        self.pasteTextUseCase = pasteTextUseCase
        self.viewPortConfiguration = viewPortConfiguration
    }

    func paste(at index: PasteIndex) {
        guard let clip = getClip(at: index) else { return }

        // TODO: - Test order! It must move clip, THEN hide, and THEN paste
        clipsRepository.moveAfterPins(index: clipIndex(for: index))
        hideAppUseCase.hide()
        pasteTextUseCase.paste(text: clip.text)
    }

    private func getClip(at index: PasteIndex) -> Clip? {
        let indexToPaste = clipIndex(for: index)
        if clipsRepository.lastClips.indices.contains(indexToPaste) {
            return clipsRepository.lastClips[indexToPaste]
        } else {
            return nil
        }
    }

    private func clipIndex(for pasteIndex: PasteIndex) -> Int {
        switch pasteIndex {
        case .index(let index):
            let selectedPage = viewPortRepository.lastPosition / viewPortConfiguration.clipsPerPage
            return selectedPage * viewPortConfiguration.clipsPerPage + index
        case .selected:
            return viewPortRepository.lastPosition
        }
    }
}
