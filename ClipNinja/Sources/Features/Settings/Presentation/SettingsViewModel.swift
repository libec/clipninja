import Combine
import Foundation

enum SettingsViewModelEvent: Equatable {
    case lifecycle(LifecycleEvent)
    case settingsEvent(SettingsEvent)

    enum SettingsEvent: Equatable {
        case togglePasteDirectly
        case toggleLaunchAtLogin
    }
}

protocol SettingsViewModel: ObservableObject {
    var launchAtLogin: Bool { get }
    var pasteDirectly: Bool { get }

    func onEvent(_ event: SettingsViewModelEvent)
}

final class SettingsViewModelImpl: SettingsViewModel {

    @Published var pasteDirectly: Bool = false
    @Published var launchAtLogin = false

    private var subscriptions = Set<AnyCancellable>()

    private let toggleSettingsUseCase: ToggleSettingsUseCase
    private let getSettingsUseCase: GetSettingsUseCase

    init(
        toggleSettingsUseCase: ToggleSettingsUseCase,
        getSettingsUseCase: GetSettingsUseCase
    ) {
        self.toggleSettingsUseCase = toggleSettingsUseCase
        self.getSettingsUseCase = getSettingsUseCase
    }

    func onEvent(_ event: SettingsViewModelEvent) {
        switch event {
        case .settingsEvent(.togglePasteDirectly):
            toggleSettingsUseCase.toggle(setting: .pasteDirectly)
        case .settingsEvent(.toggleLaunchAtLogin):
            toggleSettingsUseCase.toggle(setting: .launchAtLogin)
        case .lifecycle(.appear):
            subscribe()
        }
    }

    private func subscribe() {
        getSettingsUseCase.settings
            .sink { [unowned self] newSettings in
                self.pasteDirectly = newSettings.pasteDirectly
                self.launchAtLogin = newSettings.launchAtLogin
            }
            .store(in: &subscriptions)
    }
}
