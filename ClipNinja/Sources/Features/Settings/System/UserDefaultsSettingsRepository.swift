import Foundation
import ApplicationServices
import Combine

final class UserDefaultsSettingsRepository: SettingsRepository {

    private let userDefaults: UserDefaults

    private let settingsKey = "Settings"
    private var currentSettingsSubject: CurrentValueSubject<Settings, Never>
    var settings: AnyPublisher<Settings, Never> { currentSettingsSubject.eraseToAnyPublisher() }
    var lastSettings: Settings {
        currentSettingsSubject.value
    }

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        let settings = userDefaults.object(forKey: settingsKey) as? Settings
        self.currentSettingsSubject = CurrentValueSubject(settings ?? .default)
    }

    var shouldPasteDirectly: Bool {
        lastSettings.pasteDirectly && accessibilitySettingsAllowed
    }

    private var accessibilitySettingsAllowed: Bool {
        return AXIsProcessTrusted()
    }

    func togglePasteDirectly() {
        var newSettings = lastSettings
        newSettings.pasteDirectly.toggle()
        currentSettingsSubject.send(newSettings)
    }
}
