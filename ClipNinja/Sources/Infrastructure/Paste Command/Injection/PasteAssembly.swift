import Swinject
import SwinjectAutoregistration

struct PasteAssembly: Assembly {
    
    init() { }

    func assemble(container: Container) {
        container.autoregister(PasteCommand.self, initializer: SystemPasteCommand.init)
    }
}
