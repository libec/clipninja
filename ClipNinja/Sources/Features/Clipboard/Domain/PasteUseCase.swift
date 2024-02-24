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
    private let checkTutorialUseCase: CheckTutorialUseCase
    private let currentTutorialUseCase: CurrentTutorialUseCase
    private let viewPortConfiguration: ViewPortConfiguration
    private let settingsRepository: SettingsRepository

    init(
        clipsRepository: ClipsRepository,
        viewPortRepository: ViewPortRepository,
        hideAppUseCase: HideAppUseCase,
        pasteTextUseCase: PasteTextUseCase,
        checkTutorialUseCase: CheckTutorialUseCase,
        currentTutorialUseCase: CurrentTutorialUseCase,
        viewPortConfiguration: ViewPortConfiguration,
        settingsRepository: SettingsRepository
    ) {
        self.clipsRepository = clipsRepository
        self.viewPortRepository = viewPortRepository
        self.hideAppUseCase = hideAppUseCase
        self.pasteTextUseCase = pasteTextUseCase
        self.checkTutorialUseCase = checkTutorialUseCase
        self.currentTutorialUseCase = currentTutorialUseCase
        self.viewPortConfiguration = viewPortConfiguration
        self.settingsRepository = settingsRepository
    }

    func paste(at index: PasteIndex) {
        guard let clip = getClip(at: index) else { return }

        let shouldMoveClipToMostRecent = !clip.pinned && settingsRepository.lastSettings.movePastedClipToTop
        if shouldMoveClipToMostRecent {
            clipsRepository.moveAfterPins(index: clipIndex(for: index))
        }
        checkTutorialUseCase.checkTutorials(for: .pasteText)
        if currentTutorialUseCase.getCurrent() == nil {
            hideAppUseCase.hide()
        }
        clipsRepository.lastPastedClip = clip
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
