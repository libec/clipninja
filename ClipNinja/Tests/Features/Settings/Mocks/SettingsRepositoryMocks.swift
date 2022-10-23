@testable import ClipNinjaPackage
import Combine

class SettingsRepositorySpy: SettingsRepository {
    var shouldPasteDirectly: Bool = true

    var settings: AnyPublisher<Settings, Never> = Just(.default).eraseToAnyPublisher()
    var lastSettings: Settings = .default

    var toggleCalled: Bool?

    func togglePasteDirectly() {
        toggleCalled = true
    }
}

class SettingsRepositoryStub: SettingsRepository {

    var lastSettings: Settings

    let shouldPasteDirectly: Bool

    init(shouldPasteDirectly: Bool, lastSettings: Settings = .default) {
        self.lastSettings = lastSettings
        self.shouldPasteDirectly = shouldPasteDirectly
    }

    var settings: AnyPublisher<Settings, Never> {
        Just(lastSettings)
            .eraseToAnyPublisher()
    }

    func togglePasteDirectly() {

    }
}
