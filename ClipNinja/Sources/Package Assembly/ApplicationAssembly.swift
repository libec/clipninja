import Swinject

public struct ApplicationAssembly {

    private var assemblies: [Assembly] {
        [
            InstanceProviderAssembly(),
            SettingsInfrastructureAssembly(),
            SettingsFeatureAssembly(),
            ClipboardFeatureAssembly(),
            ClipboardInfrastructureAssembly(),
            PasteAssembly(),
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
