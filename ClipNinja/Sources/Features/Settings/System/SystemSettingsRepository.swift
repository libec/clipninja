import Foundation
import ApplicationServices
import Combine
import ServiceManagement

final class SystemSettingsRepository: SettingsRepository {

    private let userDefaults: UserDefaults

    private let pasteDirectlyKey = "SettingsPasteDirectly"
    private var currentSettingsSubject: CurrentValueSubject<Settings, Never>
    var settings: AnyPublisher<Settings, Never> { currentSettingsSubject.eraseToAnyPublisher() }
    var lastSettings: Settings {
        currentSettingsSubject.value
    }

    private var subscriptions = Set<AnyCancellable>()

    init(
        userDefaults: UserDefaults
    ) {
        self.userDefaults = userDefaults
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
        let appService = SMAppService.mainApp

        do {
            if appService.status == .enabled {
                try appService.unregister()
            } else {
                try appService.register()
            }
        } catch {
            log(message: "Launch at login error: \(error.localizedDescription)")
        }

        log(message: "Launch at login new status: \(appService.status.description)")

        currentSettingsSubject.send(makeSettings())
    }

    private func makeSettings() -> Settings {
        Settings(
           pasteDirectly: userDefaults.bool(forKey: pasteDirectlyKey),
           launchAtLogin: SMAppService.mainApp.status == .enabled
       )
    }
}

fileprivate extension SMAppService.Status {
    var description: String {
        switch self {
        case .enabled:
            return "enabled"
        case .requiresApproval:
            return "requiresApproval"
        case .notFound:
            return "not found"
        case .notRegistered:
            return "not registered"
        @unknown default:
            return "unknown"
        }
    }
}
