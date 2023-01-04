import Foundation
import ApplicationServices
import Combine

final class SystemSettingsRepository: SettingsRepository {

    private let userDefaults: UserDefaults
    private let launchAtLoginResource: LaunchAtLoginResource

    private let pasteDirectlyKey = "SettingsPasteDirectly"
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
        self.currentSettingsSubject = CurrentValueSubject(Settings.default)
        self.currentSettingsSubject.send(makeSettings())
    }

    var shouldPasteDirectly: Bool {
        lastSettings.pasteDirectly && accessibilitySettingsAllowed
    }

    private var accessibilitySettingsAllowed: Bool {
        return AXIsProcessTrusted()
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

    private func makeSettings() -> Settings {
        Settings(
           pasteDirectly: userDefaults.bool(forKey: pasteDirectlyKey),
           launchAtLogin: launchAtLoginResource.enabled
       )
    }
}
