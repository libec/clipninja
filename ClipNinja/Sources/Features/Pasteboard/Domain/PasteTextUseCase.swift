protocol PasteTextUseCase {
    func paste(text: String)
}

final class PasteTextUseCaseImpl: PasteTextUseCase {

    let pasteboardResource: PasteboardResource
    let settingsRepository: SettingsRepository
    let permissionsResource: PermissionsResource
    let pasteCommand: PasteCommand

    init(
        pasteboardResource: PasteboardResource,
        settingsRepository: SettingsRepository,
        permissionsResource: PermissionsResource,
        pasteCommand: PasteCommand
    ) {
        self.pasteboardResource = pasteboardResource
        self.settingsRepository = settingsRepository
        self.permissionsResource = permissionsResource
        self.pasteCommand = pasteCommand
    }

    func paste(text: String) {
        pasteboardResource.insert(text: text)
        if settingsRepository.lastSettings.pasteDirectly && permissionsResource.pastingAllowed {
            pasteCommand.paste()
        }
    }
}
