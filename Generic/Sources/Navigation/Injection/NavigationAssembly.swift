import Swinject
import SwinjectAutoregistration
import AppKit
import Infrastructure

public struct NavigationAssembly: Assembly {

    public init() { }
    
    public func assemble(container: Container) {
        container.register(Navigation.self) { resolver in
            AppKitNavigation(
                application: NSApplication.shared,
                shortcutObserver: resolver.resolve(ShortcutObserver.self)!
            )
        }
        .inObjectScope(.container)
    }

    public func loaded(resolver: Resolver) {
        _ = resolver.resolve(Navigation.self)!
    }
}
