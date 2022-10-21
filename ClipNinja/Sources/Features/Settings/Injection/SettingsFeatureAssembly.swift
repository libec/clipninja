import Swinject
import SwinjectAutoregistration
import SwiftUI

struct SettingsFeatureAssembly: Assembly {

    init() { }
    
    func assemble(container: Container) {
        container.register(SettingsView.self) { resolver in
            SettingsView(recordShortcutView: resolver.resolve(AnyView.self, name: AssemblyKeys.recordShortcutView.rawValue)!)
        }
        container.autoregister(SettingsRepository.self, initializer: UserDefaultsSettingsRepository.init)
            .inObjectScope(.container)
    }
}
