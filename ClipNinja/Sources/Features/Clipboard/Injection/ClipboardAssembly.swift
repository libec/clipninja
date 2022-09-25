import Swinject
import SwinjectAutoregistration

public struct ClipboardAssembly: Assembly {

    public init() { }
    
    public func assemble(container: Container) {
        container.autoregister(ClipboardView.self, initializer: ClipboardView.init)
        container.autoregister((any ClipboardViewModel).self, initializer: ClipboardViewModelImpl.init)
    }
}