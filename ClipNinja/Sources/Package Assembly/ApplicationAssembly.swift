import Swinject

public struct ApplicationAssembly {

    private var assemblies: [Assembly] {
        [
            ClipboardAssembly(),
            InstanceProviderAssembly(),
            NavigationAssembly(),
            PasteboardAssembly(),
            SettingsAssembly(),
            SystemAssembly(),
            TutorialAssembly()
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
