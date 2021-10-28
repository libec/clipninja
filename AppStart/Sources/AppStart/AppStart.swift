import Swinject
import Logger
import InstanceProvider
import Clipboard

public final class AppStart {

    private var appAssemblies: [Assembly] = [
        InstanceProviderAssembly(),
        ClipboardAssembly(),
    ]

    private let appSpecificAssemblies: [Assembly]

    public init(appSpecificAssemblies: [Assembly]) {
        self.appSpecificAssemblies = appSpecificAssemblies
        log(message: "App inited")
    }

    public func startApp<Instance>() -> Instance {
        defer {
            log(message: "App started")
        }
        let assembler = Assembler()
        assembler.apply(assemblies: appAssemblies)
        assembler.apply(assemblies: appSpecificAssemblies)
        return assembler.resolver.resolve(Instance.self)!
    }
}
