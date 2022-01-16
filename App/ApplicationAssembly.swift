import Swinject
import InstanceProvider
import Settings
import Clipboard
import Shortcuts
import Navigation

public struct ApplicationAssembly {

    private var assemblies: [Assembly] {
        [
            InstanceProviderAssembly(),
            SettingsAssembly(),
            ClipboardAssembly(),
            ShortcutsAssembly(),
            NavigationAssembly()
        ]
    }

    public func resolveDependencyGraph<Instance>() -> Instance {
        let assembler = Assembler()
        assembler.apply(assemblies: assemblies)
        return assembler.resolver.resolve(Instance.self)!
    }
}
