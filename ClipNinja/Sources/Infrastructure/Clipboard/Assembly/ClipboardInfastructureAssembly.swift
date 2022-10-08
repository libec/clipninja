import Swinject
import SwinjectAutoregistration

struct ClipboardInfrastructureAssembly: Assembly {

    init() { }

    func assemble(container: Container) {
        container.autoregister(ViewPortRepository.self, initializer: InMemoryViewPortRepository.init)
            .inObjectScope(.container)
    }
}

