import Swinject

class SwinjectInstanceProvider: InstanceProvider {
    let resolver: Resolver

    init(resolver: Resolver) {
        self.resolver = resolver
    }

    func resolve<Instance>(_ type: Instance.Type) -> Instance {
        resolver.resolve(type)!
    }

    func resolve<Instance>(_ type: Instance.Type, argument: some Any) -> Instance {
        resolver.resolve(type, argument: argument)!
    }

    func resolve<Instance>(_ type: Instance.Type, name: String) -> Instance {
        resolver.resolve(type, name: name)!
    }
}
