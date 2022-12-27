protocol ToggleLaunchAtLoginUseCase {
    func toggle()
}

final class ToggleLaunchAtLoginUseCaseImpl: ToggleLaunchAtLoginUseCase {

    private let settingsRepository: SettingsRepository

    init(settingsRepository: SettingsRepository) {
        self.settingsRepository = settingsRepository
    }

    func toggle() {
        settingsRepository.toggleLaunchAtLogin()
    }
}
