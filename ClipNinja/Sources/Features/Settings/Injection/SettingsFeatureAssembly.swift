import Swinject
import SwinjectAutoregistration

struct SettingsFeatureAssembly: Assembly {

    init() { }
    
    func assemble(container: Container) {
        container.autoregister(SettingsView.self, initializer: SettingsView.init)
    }
}
