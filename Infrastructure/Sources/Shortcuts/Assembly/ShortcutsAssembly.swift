import Swinject
import SwinjectAutoregistration

public struct ShortcutsAssembly: Assembly {

    public init() { }
    
    public func assemble(container: Container) {
        container.autoregister(ShortcutObserver.self, initializer: SystemShortcutObserver.init)
            .inObjectScope(.container)
    }

    public func loaded(resolver: Resolver) {
        resolver.resolve(ShortcutObserver.self)!.observe()
    }
}
