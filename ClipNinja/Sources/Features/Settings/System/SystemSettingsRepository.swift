import Combine
import Foundation

final class SystemSettingsRepository: SettingsRepository {
    private let userDefaults: UserDefaults
    private let launchAtLoginResource: LaunchAtLoginResource

    private let pasteDirectlyKey = "SettingsPasteDirectly"
    private let movePastedClipToTopKey = "SettingsMovePastedClipToTop"
    private var currentSettingsSubject: CurrentValueSubject<Settings, Never>
    var settings: AnyPublisher<Settings, Never> { currentSettingsSubject.eraseToAnyPublisher() }
    var lastSettings: Settings {
        currentSettingsSubject.value
    }

    private var subscriptions = Set<AnyCancellable>()

    init(
        userDefaults: UserDefaults,
        launchAtLoginResource: LaunchAtLoginResource
    ) {
        self.userDefaults = userDefaults
        self.launchAtLoginResource = launchAtLoginResource
        currentSettingsSubject = CurrentValueSubject(Settings.default)
        currentSettingsSubject.send(makeSettings())
    }

    func togglePasteDirectly() {
        userDefaults.set(!lastSettings.pasteDirectly, forKey: pasteDirectlyKey)
        currentSettingsSubject.send(makeSettings())
    }

    func toggleLaunchAtLogin() {
        if launchAtLoginResource.enabled {
            launchAtLoginResource.disable()
        } else {
            launchAtLoginResource.enable()
        }

        currentSettingsSubject.send(makeSettings())
    }

    func toggleMovePastedClipToTop() {
        userDefaults.set(!lastSettings.movePastedClipToTop, forKey: movePastedClipToTopKey)
        currentSettingsSubject.send(makeSettings())
    }

    private func makeSettings() -> Settings {
        let movePastedClipToTop: Bool? = userDefaults.value(forKey: movePastedClipToTopKey) as? Bool
        return Settings(
            pasteDirectly: userDefaults.bool(forKey: pasteDirectlyKey),
            launchAtLogin: launchAtLoginResource.enabled,
            movePastedClipToTop: movePastedClipToTop ?? true
        )
    }
}
