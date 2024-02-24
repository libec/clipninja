@testable import ClipNinjaPackage
import Combine

typealias SettingsRepositoryDummy = SettingsRepositorySpy
class SettingsRepositorySpy: SettingsRepository {

    var settings: AnyPublisher<Settings, Never> = Just(.default).eraseToAnyPublisher()
    var lastSettings: Settings = .default

    var togglePasteDirectlyCalled: Bool?
    var toggleLaunchAtLoginCalled: Bool?
    var toggleMovePastedClipToTopCalled: Bool?

    func togglePasteDirectly() {
        togglePasteDirectlyCalled = true
    }

    func toggleLaunchAtLogin() {
        toggleLaunchAtLoginCalled = true
    }

    func toggleMovePastedClipToTop() {
        toggleMovePastedClipToTopCalled = true
    }
}

class SettingsRepositoryStub: SettingsRepository {

    var lastSettings: Settings

    var passthroughSubject = PassthroughSubject<Settings, Never>()

    func notify(newSettings: Settings) {
        passthroughSubject.send(newSettings)
    }

    init(lastSettings: Settings = .default) {
        self.lastSettings = lastSettings
    }

    var settings: AnyPublisher<Settings, Never> {
        passthroughSubject
            .eraseToAnyPublisher()
    }

    func toggleMovePastedClipToTop() {

    }
    
    func togglePasteDirectly() {

    }

    func toggleLaunchAtLogin() {

    }
}
