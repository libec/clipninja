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
            SystemAssembly(),
            NavigationAssembly()
        ]
    }

    private let systemAssemblies: [Assembly]

    public init(systemAssemblies: [Assembly]) {
        self.systemAssemblies = systemAssemblies
    }

    public func resolveDependencyGraph<Instance>() -> Instance {
        let assembler = Assembler()
        assembler.apply(assemblies: assemblies + systemAssemblies)
        return assembler.resolver.resolve(Instance.self)!
    }
}
