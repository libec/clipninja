import Combine

protocol SettingsRepository {
    var shouldPasteDirectly: Bool { get }

    var settings: AnyPublisher<Settings, Never> { get }
    var lastSettings: Settings { get }

    func togglePasteDirectly()
}
