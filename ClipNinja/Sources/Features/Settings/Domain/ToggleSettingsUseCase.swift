enum ToggleSetting {
    case launchAtLogin
    case pasteDirectly
    case movePastedClipToTop
}

protocol ToggleSettingsUseCase {
    @discardableResult
    func toggle(setting: ToggleSetting) -> Result<Void, ToggleSettingsError>
}

enum ToggleSettingsError: Error {
    case permissionNotGranted
}

final class ToggleSettingsUseCaseImpl: ToggleSettingsUseCase {

    private let settingsRepository: SettingsRepository
    private let permissionsResource: PermissionsResource

    init(
        settingsRepository: SettingsRepository,
        permissionsResource: PermissionsResource
    ) {
        self.settingsRepository = settingsRepository
        self.permissionsResource = permissionsResource
    }

    @discardableResult
    func toggle(setting: ToggleSetting) -> Result<Void, ToggleSettingsError> {
        switch setting {
        case .launchAtLogin:
            settingsRepository.toggleLaunchAtLogin()
            return .success(())
        case .movePastedClipToTop:
            settingsRepository.toggleMovePastedClipToTop()
            return .success(())
        case .pasteDirectly:
            if permissionsResource.pastingAllowed || settingsRepository.lastSettings.pasteDirectly {
                settingsRepository.togglePasteDirectly()
                return .success(())
            } else {
                return .failure(.permissionNotGranted)
            }
        }
    }
}
