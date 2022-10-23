import Combine

protocol SettingsViewModel: ObservableObject {
    var pasteDirectlySettings: Bool { get }
    var allowedToPaste: Bool { get }
}

final class SettingsViewModelImpl: SettingsViewModel {
    var pasteDirectlySettings: Bool = true
    var allowedToPaste: Bool = false
}
