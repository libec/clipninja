import Swinject
import SwinjectAutoregistration
import Navigation

public final class ClipboardAssembly: Assembly {

    public init() { }
    
    public func assemble(container: Container) {
        container.autoregister(ClipboardView.self, initializer: ClipboardView.init)
    }
}
