struct Settings: Equatable, Codable {
    var pasteDirectly: Bool
    var launchAtLogin: Bool
    var movePastedClipToTop: Bool

    static var `default`: Settings {
        Settings(pasteDirectly: false, launchAtLogin: false, movePastedClipToTop: true)
    }

    init(pasteDirectly: Bool, launchAtLogin: Bool, movePastedClipToTop: Bool) {
        self.pasteDirectly = pasteDirectly
        self.launchAtLogin = launchAtLogin
        self.movePastedClipToTop = movePastedClipToTop
    }
}
