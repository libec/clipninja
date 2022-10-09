import Foundation
import Swinject
import SwinjectAutoregistration

struct SettingsInfrastructureAssembly: Assembly {

    init() { }

    func assemble(container: Container) {
        container.autoregister(SettingsRepository.self, initializer: UserDefaultsSettingsRepository.init)
            .inObjectScope(.container)
    }
}
