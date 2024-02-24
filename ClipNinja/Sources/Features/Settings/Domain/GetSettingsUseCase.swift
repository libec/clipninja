import Combine

protocol GetSettingsUseCase {
    var settings: AnyPublisher<Settings, Never> { get }
}

final class GetSettingsUseCaseImpl: GetSettingsUseCase {
    private let settingsRepository: SettingsRepository

    init(settingsRepository: SettingsRepository) {
        self.settingsRepository = settingsRepository
    }

    var settings: AnyPublisher<Settings, Never> {
        settingsRepository.settings
    }
}
