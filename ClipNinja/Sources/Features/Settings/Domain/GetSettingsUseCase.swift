import Combine

protocol GetSettingsUseCase {
    var settings: AnyPublisher<Settings, Never> { get }
}

final class GetSettingsUseCaseImpl: GetSettingsUseCase {

    private let settingsRespository: SettingsRepository

    init(settingsRespository: SettingsRepository) {
        self.settingsRespository = settingsRespository
    }

    var settings: AnyPublisher<Settings, Never> {
        settingsRespository.settings
    }
}
