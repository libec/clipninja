import Swinject
import Infrastructure
import Generic

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

    public init() { }

    public func resolveDependencyGraph<Instance>() -> Instance {
        let assembler = Assembler()
        assembler.apply(assemblies: assemblies)
        return assembler.resolver.resolve(Instance.self)!
    }
}
