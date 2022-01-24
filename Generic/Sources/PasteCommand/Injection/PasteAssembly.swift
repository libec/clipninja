import Swinject
import SwinjectAutoregistration

public struct PasteAssembly: Assembly {
    
    public init() { }

    public func assemble(container: Container) {
        container.autoregister(PasteCommand.self, initializer: SystemPasteCommand.init)
    }
}
