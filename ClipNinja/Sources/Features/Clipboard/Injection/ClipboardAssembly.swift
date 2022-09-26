import Swinject
import SwinjectAutoregistration

struct ClipboardAssembly: Assembly {

    init() { }
    
    func assemble(container: Container) {
        container.autoregister(ClipboardView.self, initializer: ClipboardView.init)
        container.autoregister((any ClipboardViewModel).self, initializer: ClipboardViewModelImpl.init)
    }
}
