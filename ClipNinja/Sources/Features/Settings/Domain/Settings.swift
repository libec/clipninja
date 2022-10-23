struct Settings: Codable {
    var pasteDirectly: Bool

    static var `default`: Settings {
        Settings(pasteDirectly: false)
    }
}
