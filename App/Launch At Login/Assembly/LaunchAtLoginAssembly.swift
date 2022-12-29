import ClipNinjaPackage
import Swinject
import SwinjectAutoregistration

struct LaunchAtLoginAssembly: Assembly {
    func assemble(container: Container) {
        container.autoregister(LaunchAtLoginService.self, initializer: LaunchAtLoginServiceImpl.init)
            .inObjectScope(.container)
    }
}
