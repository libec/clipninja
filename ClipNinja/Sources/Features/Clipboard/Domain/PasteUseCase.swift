import Foundation
import ApplicationServices
import AppKit

protocol PasteUseCase {
    func paste(at index: PasteIndex)
}

protocol SettingsRepository {
    var shouldPasteDirectly: Bool { get }
}

protocol PasteTextUseCase {
    // check settings repository
    // fill pasteboard
    // run paste command
    func paste(text: String)
}

// TODO: - Rename PasteClipUseCase
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
        guard let clip = getClipboardRecord(at: index) else { return }

        hideAppUseCase.hide()
        pasteTextUseCase.paste(text: clip.text)
    }

    private func getClipboardRecord(at index: PasteIndex) -> ClipboardRecord? {
        switch index {
        case .index(let index):
            let selectedPage = viewPortRepository.lastPosition / viewPortConfiguration.clipsPerPage
            let indexToPaste = selectedPage * viewPortConfiguration.clipsPerPage + index
            if clipsRepository.lastClips.indices.contains(indexToPaste) {
                return clipsRepository.lastClips[indexToPaste]
            } else {
                return nil
            }
        case .selected:
            if clipsRepository.lastClips.indices.contains(viewPortRepository.lastPosition) {
                return clipsRepository.lastClips[viewPortRepository.lastPosition]
            } else {
                return nil
            }
        }
    }
}
