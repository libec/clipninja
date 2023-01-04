protocol PasteTextUseCase {
    func paste(text: String)
}

final class PasteTextUseCaseImpl: PasteTextUseCase {

    let pasteboardResource: PasteboardResource
    let settingsRepository: SettingsRepository
    let pasteCommand: PasteCommand

    init(
        pasteboardResource: PasteboardResource,
        settingsRepository: SettingsRepository,
        pasteCommand: PasteCommand
    ) {
        self.pasteboardResource = pasteboardResource
        self.settingsRepository = settingsRepository
        self.pasteCommand = pasteCommand
    }

    func paste(text: String) {
        pasteboardResource.insert(text: text)
        // check settings
        // check permissions
        if settingsRepository.shouldPasteDirectly {
            pasteCommand.paste()
        }
    }
}
