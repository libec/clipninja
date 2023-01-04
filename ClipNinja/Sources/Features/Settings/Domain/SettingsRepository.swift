import Combine

protocol SettingsRepository {
    var settings: AnyPublisher<Settings, Never> { get }
    var lastSettings: Settings { get }

    func togglePasteDirectly()
    func toggleLaunchAtLogin()
}
