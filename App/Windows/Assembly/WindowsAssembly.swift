import ClipNinjaPackage
import Swinject
import SwinjectAutoregistration
import SwiftUI

struct WindowsAssembly: Assembly {

    func assemble(container: Container) {
        container.autoregister(WindowsController.self, initializer: WindowsController.init)
            .inObjectScope(.container)
        container.autoregister(WindowsFactory.self, initializer: WindowsFactoryImpl.init)
        container.autoregister(MenuBarController.self, initializer: MenuBarController.init)
            .inObjectScope(.container)
    }
}
