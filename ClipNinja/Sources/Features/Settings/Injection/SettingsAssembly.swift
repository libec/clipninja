import Swinject
import SwinjectAutoregistration

struct SettingsAssembly: Assembly {

    init() { }
    
    func assemble(container: Container) {
        container.autoregister(SettingsView.self, initializer: SettingsView.init)
    }
}
