struct Settings: Equatable, Codable {
    var pasteDirectly: Bool

    static var `default`: Settings {
        Settings(pasteDirectly: false)
    }

    init(pasteDirectly: Bool) {
        self.pasteDirectly = pasteDirectly
    }
}
