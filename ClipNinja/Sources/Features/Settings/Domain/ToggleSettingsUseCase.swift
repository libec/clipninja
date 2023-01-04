enum ToggleSetting {
    case launchAtLogin
    case pasteDirectly
}

protocol ToggleSettingsUseCase {
    func toggle(setting: ToggleSetting)
}

final class ToggleSettingsUseCaseImpl: ToggleSettingsUseCase {

    private let settingsRepository: SettingsRepository

    init(settingsRepository: SettingsRepository) {
        self.settingsRepository = settingsRepository
    }

    func toggle(setting: ToggleSetting) {
        switch setting {
        case .launchAtLogin:
            settingsRepository.toggleLaunchAtLogin()
        case .pasteDirectly:
            settingsRepository.togglePasteDirectly()
        }
    }
}
