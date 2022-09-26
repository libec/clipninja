import Swinject
import SwinjectAutoregistration
import AppKit

struct NavigationAssembly: Assembly {

    init() { }
    
    func assemble(container: Container) {
        container.register(Navigation.self) { resolver in
            AppKitNavigation(
                shortcutObserver: resolver.resolve(ShortcutObserver.self)!
            )
        }
        .inObjectScope(.container)
    }

    func loaded(resolver: Resolver) {
        _ = resolver.resolve(Navigation.self)!
    }
}
