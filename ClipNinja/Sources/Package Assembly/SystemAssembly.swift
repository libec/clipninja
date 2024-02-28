import Foundation
import Swinject
import SwinjectAutoregistration

struct SystemAssembly: Assembly {
    init() {}

    func assemble(container: Container) {
        container.register(UserDefaults.self) { _ in UserDefaults.standard }
        container.autoregister(JSONDecoder.self, initializer: JSONDecoder.init).inObjectScope(.container)
        container.autoregister(JSONEncoder.self, initializer: JSONEncoder.init).inObjectScope(.container)
    }
}
