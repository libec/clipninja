import Combine
import Foundation

enum SettingsViewModelEvent: Equatable {
    case lifecycle(LifecycleEvent)
    case settingsEvent(SettingsEvent)

    enum SettingsEvent: Equatable {
        case togglePasteDirectly
        case toggleLaunchAtLogin
        case showPasteDirectlyHint
    }
}

protocol SettingsViewModel: ObservableObject {
    var launchAtLogin: Bool { get }
    var pasteDirectly: Bool { get }
    var showPasteDirectlyHint: Bool { get }

    func onEvent(_ event: SettingsViewModelEvent)
}

final class SettingsViewModelImpl: SettingsViewModel {

    @Published var pasteDirectly = false
    @Published var launchAtLogin = false
    @Published var showPasteDirectlyHint = false

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
            let toggleResult = toggleSettingsUseCase.toggle(setting: .pasteDirectly)
            if toggleResult.error() == .permissionNotGranted {
                showPasteDirectlyHint = true
            }
        case .settingsEvent(.toggleLaunchAtLogin):
            toggleSettingsUseCase.toggle(setting: .launchAtLogin)
        case .settingsEvent(.showPasteDirectlyHint):
            showPasteDirectlyHint.toggle()
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
