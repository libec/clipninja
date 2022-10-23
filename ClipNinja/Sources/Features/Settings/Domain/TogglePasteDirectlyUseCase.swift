protocol TogglePasteDirectlyUseCase {
    func toggle()
}

final class TogglePasteDirectlyUseCaseImpl: TogglePasteDirectlyUseCase {

    private let settingsRepository: SettingsRepository

    init(settingsRepository: SettingsRepository) {
        self.settingsRepository = settingsRepository
    }

    func toggle() {
        settingsRepository.togglePasteDirectly()
    }
}
