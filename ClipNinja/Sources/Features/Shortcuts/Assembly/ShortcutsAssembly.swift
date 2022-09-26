import Swinject
import SwinjectAutoregistration

struct ShortcutsAssembly: Assembly {

    init() { }
    
    func assemble(container: Container) {
        container.autoregister(ShortcutObserver.self, initializer: SystemShortcutObserver.init)
            .inObjectScope(.container)
    }

    func loaded(resolver: Resolver) {
        resolver.resolve(ShortcutObserver.self)!.observe()
    }
}
