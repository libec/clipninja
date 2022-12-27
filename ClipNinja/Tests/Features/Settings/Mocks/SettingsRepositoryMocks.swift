@testable import ClipNinjaPackage
import Combine

class SettingsRepositorySpy: SettingsRepository {

    var shouldPasteDirectly: Bool = true

    var settings: AnyPublisher<Settings, Never> = Just(.default).eraseToAnyPublisher()
    var lastSettings: Settings = .default

    var togglePasteDirectlyCalled: Bool?
    var toggleLaunchAtLoginCalled: Bool?

    func togglePasteDirectly() {
        togglePasteDirectlyCalled = true
    }

    func toggleLaunchAtLogin() {
        toggleLaunchAtLoginCalled = true
    }
}

class SettingsRepositoryStub: SettingsRepository {

    var lastSettings: Settings

    let shouldPasteDirectly: Bool

    var passthroughSubject = PassthroughSubject<Settings, Never>()

    func notify(newSettings: Settings) {
        passthroughSubject.send(newSettings)
    }

    init(shouldPasteDirectly: Bool = false, lastSettings: Settings = .default) {
        self.lastSettings = lastSettings
        self.shouldPasteDirectly = shouldPasteDirectly
    }

    var settings: AnyPublisher<Settings, Never> {
        passthroughSubject
            .eraseToAnyPublisher()
    }

    func togglePasteDirectly() {

    }

    func toggleLaunchAtLogin() {

    }
}
