import Foundation
import ApplicationServices
import Combine

final class UserDefaultsSettingsRepository: SettingsRepository {

    private let userDefaults: UserDefaults
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder

    private let settingsKey = "Settings"
    private var currentSettingsSubject: CurrentValueSubject<Settings, Never>
    var settings: AnyPublisher<Settings, Never> { currentSettingsSubject.eraseToAnyPublisher() }
    var lastSettings: Settings {
        currentSettingsSubject.value
    }

    private var subscriptions = Set<AnyCancellable>()

    init(
        userDefaults: UserDefaults,
        jsonEncoder: JSONEncoder,
        jsonDecoder: JSONDecoder
    ) {
        self.userDefaults = userDefaults
        self.jsonDecoder = jsonDecoder
        self.jsonEncoder = jsonEncoder
        let settings = (userDefaults.object(forKey: settingsKey) as? Data).map {
            (try? jsonDecoder.decode(Settings.self, from: $0)) ?? .default
        } ?? .default
        self.currentSettingsSubject = CurrentValueSubject(settings)

        setupPersistency()
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

    private func setupPersistency() {
        settings.sink { [unowned self] newSettings in
            if let encodedSettingsData = try? self.jsonEncoder.encode(newSettings) {
                self.userDefaults.set(encodedSettingsData, forKey: self.settingsKey)
            }
        }.store(in: &subscriptions)
    }
}
