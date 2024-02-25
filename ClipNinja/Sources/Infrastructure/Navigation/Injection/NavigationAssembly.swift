import AppKit
import Swinject
import SwinjectAutoregistration

struct NavigationAssembly: Assembly {
    init() {}

    func assemble(container: Container) {
        container.autoregister(HideAppUseCase.self, initializer: HideAppUseCaseImpl.init)
        container.autoregister(Navigation.self, initializer: NavigationImpl.init)
            .inObjectScope(.container)
        container.autoregister(ViewPortRepository.self, initializer: InMemoryViewPortRepository.init)
            .inObjectScope(.container)
        container.autoregister(ResetViewPortUseCase.self, initializer: ResetViewPortUseCaseImpl.init)
    }
}
