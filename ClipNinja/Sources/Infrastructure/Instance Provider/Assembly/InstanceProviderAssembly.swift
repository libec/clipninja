import Swinject

struct InstanceProviderAssembly: Assembly {
    init() {}

    func assemble(container: Container) {
        container.register(InstanceProvider.self) { resolver in
            SwinjectInstanceProvider(resolver: resolver)
        }.inObjectScope(.container)
    }
}
