import Swinject

public struct ApplicationAssembly {

    private var assemblies: [Assembly] {
        [
            InstanceProviderAssembly(),
            SettingsInfrastructureAssembly(),
            SettingsFeatureAssembly(),
            ClipboardFeatureAssembly(),
            ClipboardInfrastructureAssembly(),
            PasteboardAssembly(),
            ShortcutsAssembly(),
            SystemAssembly(),
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
