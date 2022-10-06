import Swinject
import SwinjectAutoregistration
import AppKit

struct NavigationAssembly: Assembly {

    init() { }
    
    func assemble(container: Container) {
        container.autoregister(HideAppUseCase.self, initializer: HideAppUseCaseImpl.init)
        container.register(Navigation.self) { resolver in
            AppKitNavigation(
                shortcutObserver: resolver.resolve(ShortcutObserver.self)!
            )
        }
        .inObjectScope(.container)
    }
}
