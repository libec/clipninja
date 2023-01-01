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

    private let togglePasteDirectlyUseCase: TogglePasteDirectlyUseCase
    private let toggleLaunchAtLoginUseCase: ToggleLaunchAtLoginUseCase
    private let getSettingsUseCase: GetSettingsUseCase

    init(
        togglePasteDirectlyUseCase: TogglePasteDirectlyUseCase,
        toggleLaunchAtLoginUseCase: ToggleLaunchAtLoginUseCase,
        getSettingsUseCase: GetSettingsUseCase
    ) {
        self.togglePasteDirectlyUseCase = togglePasteDirectlyUseCase
        self.toggleLaunchAtLoginUseCase = toggleLaunchAtLoginUseCase
        self.getSettingsUseCase = getSettingsUseCase
    }

    func onEvent(_ event: SettingsViewModelEvent) {
        switch event {
        case .settingsEvent(.togglePasteDirectly):
            togglePasteDirectlyUseCase.toggle()
        case .settingsEvent(.toggleLaunchAtLogin):
            launchAtLogin.toggle()
            toggleLaunchAtLoginUseCase.toggle()
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
