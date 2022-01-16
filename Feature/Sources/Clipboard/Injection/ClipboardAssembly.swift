import Swinject
import SwinjectAutoregistration
import Navigation

public struct ClipboardAssembly: Assembly {

    public init() { }
    
    public func assemble(container: Container) {
        container.autoregister(ClipboardView.self, initializer: ClipboardView.init)
    }
}
