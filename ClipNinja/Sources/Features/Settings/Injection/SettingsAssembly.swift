import SwiftUI
import Swinject
import SwinjectAutoregistration

struct SettingsAssembly: Assembly {
    init() {}

    func assemble(container: Container) {
        container.register(AnyView.self, name: AssemblyKeys.settingsView.rawValue) { resolver in
            AnyView(
                resolver.resolve(SettingsView<SettingsViewModelImpl>.self)!
            )
        }
        container.register(SettingsView<SettingsViewModelImpl>.self) { resolver in
            SettingsView<SettingsViewModelImpl>(
                viewModel: resolver.resolve(SettingsViewModelImpl.self)!,
                recordShortcutView: resolver.resolve(
                    AnyView.self,
                    name: AssemblyKeys.recordShortcutView.rawValue
                )!
            )
        }
        container.autoregister(SettingsViewModelImpl.self, initializer: SettingsViewModelImpl.init).implements((any SettingsViewModel).self)
        container.autoregister(SettingsRepository.self, initializer: SystemSettingsRepository.init)
            .inObjectScope(.container)
        container.autoregister(PermissionsResource.self, initializer: SystemPermissionsResource.init)
        container.autoregister(ToggleSettingsUseCase.self, initializer: ToggleSettingsUseCaseImpl.init)
        container.autoregister(GetSettingsUseCase.self, initializer: GetSettingsUseCaseImpl.init)
    }
}
