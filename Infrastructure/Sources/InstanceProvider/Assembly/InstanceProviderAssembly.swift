import Swinject

public class InstanceProviderAssembly: Assembly {

    public init() { }
    
    public func assemble(container: Container) {
        container.register(InstanceProvider.self) { resolver in
            SwinjectInstanceProvider(resolver: resolver)
        }.inObjectScope(.container)
    }
}
