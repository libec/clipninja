protocol PasteTextUseCase {
    func paste(text: String)
}

final class PasteTextUseCaseImpl: PasteTextUseCase {

    let pasteboardService: PasteboardService
    let settingsRepository: SettingsRepository
    let pasteCommand: PasteCommand

    init(
        pasteboardService: PasteboardService,
        settingsRepository: SettingsRepository,
        pasteCommand: PasteCommand
    ) {
        self.pasteboardService = pasteboardService
        self.settingsRepository = settingsRepository
        self.pasteCommand = pasteCommand
    }

    func paste(text: String) {
        pasteboardService.insert(text: text)
        if settingsRepository.shouldPasteDirectly {
            pasteCommand.paste()
        }
    }
}
