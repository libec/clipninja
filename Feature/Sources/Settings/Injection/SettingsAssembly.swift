import Swinject
import SwinjectAutoregistration

public class SettingsAssembly: Assembly {

    public init() { }
    
    public func assemble(container: Container) {
        container.autoregister(SettingsView.self, initializer: SettingsView.init)
    }
}
