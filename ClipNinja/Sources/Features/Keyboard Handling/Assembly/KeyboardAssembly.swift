import Swinject
import SwinjectAutoregistration

struct KeyboardAssembly: Assembly {

    private let shortcutObserver: ShortcutObserver

    init(shortcutObserver: ShortcutObserver) {
        self.shortcutObserver = shortcutObserver
    }

    func assemble(container: Container) {
        container.register(ShortcutObserver.self, factory: { _ in
            return shortcutObserver
        }).inObjectScope(.container)
    }

    func loaded(resolver: Resolver) {
        resolver.resolve(ShortcutObserver.self)!.observe()
    }
}
