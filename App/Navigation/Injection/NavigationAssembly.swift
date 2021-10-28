import Swinject
import SwinjectAutoregistration
import Navigation
import AppKit

final class NavigationAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(Navigation.self) { resolver in
            AppKitNavigation(
                application: NSApplication.shared
            )
        }
        .inObjectScope(.container)
    }

    func loaded(resolver: Resolver) {
        _ = resolver.resolve(Navigation.self)!
    }
}
