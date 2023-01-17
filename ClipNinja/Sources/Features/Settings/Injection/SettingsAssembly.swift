import Swinject
import SwinjectAutoregistration
import SwiftUI

struct SettingsAssembly: Assembly {

    init() { }
    
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
            .implements(PermissionsResource.self)
            .inObjectScope(.container)
        container.autoregister(ToggleSettingsUseCase.self, initializer: ToggleSettingsUseCaseImpl.init)
        container.autoregister(GetSettingsUseCase.self, initializer: GetSettingsUseCaseImpl.init)
    }
}
