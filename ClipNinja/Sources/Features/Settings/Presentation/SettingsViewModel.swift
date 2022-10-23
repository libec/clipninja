import Combine

enum SettingsViewModelEvent: Equatable {
    case lifecycle(LifecycleEvent)
    case settingsEvent(SettingsEvent)

    enum SettingsEvent: Equatable {
        case togglePasteDirectly
    }
}


protocol SettingsViewModel: ObservableObject {
    var pasteDirectlySettings: Bool { get }
    var allowedToPaste: Bool { get }

    func onEvent(_ event: SettingsViewModelEvent)
}

final class SettingsViewModelImpl: SettingsViewModel {

    @Published var pasteDirectlySettings: Bool = true
    @Published var allowedToPaste: Bool = false

    private var subscriptions = Set<AnyCancellable>()

    private let togglePasteDirectlyUseCase: TogglePasteDirectlyUseCase
    private let getSettingsUseCase: GetSettingsUseCase

    init(
        togglePasteDirectlyUseCase: TogglePasteDirectlyUseCase,
        getSettingsUseCase: GetSettingsUseCase
    ) {
        self.togglePasteDirectlyUseCase = togglePasteDirectlyUseCase
        self.getSettingsUseCase = getSettingsUseCase
    }

    func onEvent(_ event: SettingsViewModelEvent) {
        switch event {
        case .settingsEvent(.togglePasteDirectly):
            togglePasteDirectlyUseCase.toggle()
        case .lifecycle(.appear):
            subscribe()
        }
    }

    func subscribe() {
        getSettingsUseCase.settings
            .sink { [unowned self] newSettings in
                self.pasteDirectlySettings = newSettings.pasteDirectly
            }
            .store(in: &subscriptions)
    }
}
