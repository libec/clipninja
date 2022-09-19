import Swinject
import SwinjectAutoregistration

public struct SettingsAssembly: Assembly {

    public init() { }
    
    public func assemble(container: Container) {
        container.autoregister(SettingsView.self, initializer: SettingsView.init)
    }
}
