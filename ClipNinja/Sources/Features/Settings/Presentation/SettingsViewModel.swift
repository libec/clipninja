import Combine
import Foundation

enum SettingsViewModelEvent: Equatable {
    case lifecycle(LifecycleEvent)
    case settingsEvent(SettingsEvent)

    enum SettingsEvent: Equatable {
        case togglePasteDirectly
        case toggleLaunchAtLogin
        case showPasteDirectlyHint
        case showAccessibilitySettings
        case enableAccessibilitySettings
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
    private let navigation: Navigation

    init(
        toggleSettingsUseCase: ToggleSettingsUseCase,
        getSettingsUseCase: GetSettingsUseCase,
        navigation: Navigation
    ) {
        self.toggleSettingsUseCase = toggleSettingsUseCase
        self.getSettingsUseCase = getSettingsUseCase
        self.navigation = navigation
    }

    func onEvent(_ event: SettingsViewModelEvent) {
        switch event {
        case .settingsEvent(let settingsEvent):
            onEvent(settingsEvent)
        case .lifecycle(.appear):
            subscribe()
        }
    }

    private func onEvent(_ event: SettingsViewModelEvent.SettingsEvent) {
        switch event {
        case .togglePasteDirectly:
            let toggleResult = toggleSettingsUseCase.toggle(setting: .pasteDirectly)
            if toggleResult.error() == .permissionNotGranted {
                showPasteDirectlyHint = true
            }
        case .toggleLaunchAtLogin:
            toggleSettingsUseCase.toggle(setting: .launchAtLogin)
        case .showPasteDirectlyHint:
            showPasteDirectlyHint.toggle()
        case .showAccessibilitySettings:
            navigation.handle(navigationEvent: .showSystemAccessibilitySettings)
        case .enableAccessibilitySettings:
            navigation.handle(navigationEvent: .enableAccessibilitySettings)
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
