import Foundation
import ApplicationServices

final class UserDefaultsSettingsRepository: SettingsRepository {

    private let userDefaults: UserDefaults

    private let pasteDirectlyKey = "PasteDirectly"

    private var pasteDirectlySetting: Bool {
//        userDefaults.bool(forKey: pasteDirectlyKey)
        true
    }

    var shouldPasteDirectly: Bool {
        pasteDirectlySetting && accessibilitySettingsAllowed
    }

    private var accessibilitySettingsAllowed: Bool {
        return AXIsProcessTrusted()
    }

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

}
