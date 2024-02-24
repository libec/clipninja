import Combine
import Foundation

enum SettingsEvent: Equatable {
    case lifecycle(LifecycleEvent)
    case settingsEvent(Settings)

    enum Settings: Equatable {
        case togglePasteDirectly
        case toggleLaunchAtLogin
        case toggleMovePastedToTop
        case showPasteDirectlyHint
        case showAccessibilitySettings
    }
}

protocol SettingsViewModel: ObservableObject {
    var launchAtLogin: Bool { get }
    var movePastedClipToTop: Bool { get }
    var pasteDirectly: Bool { get }
    var showPasteDirectlyHint: Bool { get }

    func onEvent(_ event: SettingsEvent)
}

final class SettingsViewModelImpl: SettingsViewModel {
    @Published var pasteDirectly = false
    @Published var launchAtLogin = false
    @Published var movePastedClipToTop = true
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

    func onEvent(_ event: SettingsEvent) {
        switch event {
        case let .settingsEvent(settingsEvent):
            onEvent(settingsEvent)
        case .lifecycle(.appear):
            subscribe()
        }
    }

    private func onEvent(_ event: SettingsEvent.Settings) {
        switch event {
        case .togglePasteDirectly:
            let toggleResult = toggleSettingsUseCase.toggle(setting: .pasteDirectly)
            if toggleResult.error() == .permissionNotGranted {
                showPasteDirectlyHint = true
            }
        case .toggleLaunchAtLogin:
            toggleSettingsUseCase.toggle(setting: .launchAtLogin)
        case .toggleMovePastedToTop:
            toggleSettingsUseCase.toggle(setting: .movePastedClipToTop)
        case .showPasteDirectlyHint:
            showPasteDirectlyHint.toggle()
        case .showAccessibilitySettings:
            navigation.handle(navigationEvent: .showSystemSettings)
        }
    }

    private func subscribe() {
        getSettingsUseCase.settings
            .sink { [unowned self] newSettings in
                pasteDirectly = newSettings.pasteDirectly
                movePastedClipToTop = newSettings.movePastedClipToTop
                launchAtLogin = newSettings.launchAtLogin
            }
            .store(in: &subscriptions)
    }
}
