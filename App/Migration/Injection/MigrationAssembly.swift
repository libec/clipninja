import Swinject
import SwinjectAutoregistration

struct MigrationAssembly: Assembly {
    func assemble(container: Container) {
        container.autoregister(MigrationController.self, initializer: MigrationController.init)
            .inObjectScope(.container)
    }
}
