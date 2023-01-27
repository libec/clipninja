import Swinject
import SwinjectAutoregistration
import AppKit

struct NavigationAssembly: Assembly {

    init() { }
    
    func assemble(container: Container) {
        container.autoregister(HideAppUseCase.self, initializer: HideAppUseCaseImpl.init)
        container.autoregister(Navigation.self, initializer: NavigationImpl.init)
            .inObjectScope(.container)
        container.autoregister(ViewPortRepository.self, initializer: InMemoryViewPortRepository.init)
            .inObjectScope(.container)
    }
}
