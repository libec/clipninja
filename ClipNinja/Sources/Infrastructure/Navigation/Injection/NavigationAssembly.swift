import Swinject
import SwinjectAutoregistration
import AppKit

public struct NavigationAssembly: Assembly {

    public init() { }
    
    public func assemble(container: Container) {
        container.register(Navigation.self) { resolver in
            AppKitNavigation(
                shortcutObserver: resolver.resolve(ShortcutObserver.self)!
            )
        }
        .inObjectScope(.container)
    }

    public func loaded(resolver: Resolver) {
        _ = resolver.resolve(Navigation.self)!
    }
}
