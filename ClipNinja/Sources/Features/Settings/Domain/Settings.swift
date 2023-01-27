struct Settings: Equatable, Codable {
    var pasteDirectly: Bool
    var launchAtLogin: Bool

    static var `default`: Settings {
        Settings(pasteDirectly: false, launchAtLogin: false)
    }

    init(pasteDirectly: Bool, launchAtLogin: Bool) {
        self.pasteDirectly = pasteDirectly
        self.launchAtLogin = launchAtLogin
    }
}
