import ClipNinjaPackage
import Swinject
import SwinjectAutoregistration

struct LaunchAtLoginAssembly: Assembly {
    func assemble(container: Container) {
        container.autoregister(LaunchAtLoginResource.self, initializer: LaunchAtLoginSystemResource.init)
            .inObjectScope(.container)
    }
}
