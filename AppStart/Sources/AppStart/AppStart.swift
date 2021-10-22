import Swinject
import Logger
import InstanceProvider

public struct AppStart {

    private var appAssemblies: [Assembly] = [
        InstanceProviderAssembly(),
    ]

    public init() { }

    public func startApp<Instance>() -> Instance {
        let assembler = Assembler()
        assembler.apply(assemblies: appAssemblies)
        return assembler.resolver.resolve(Instance.self)!
    }
}
