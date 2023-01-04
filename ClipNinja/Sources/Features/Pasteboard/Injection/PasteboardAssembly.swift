import AppKit
import Swinject
import SwinjectAutoregistration

struct PasteboardAssembly: Assembly {
    
    init() { }

    func assemble(container: Container) {
        container.autoregister(PasteCommand.self, initializer: SystemPasteCommand.init)
        container.autoregister(PasteTextUseCase.self, initializer: PasteTextUseCaseImpl.init)
        container.autoregister(PasteboardResource.self, initializer: SystemPasteboardResource.init)
        container.autoregister(PasteboardObserver.self, initializer: PasteboardObserverImpl.init)
        container.register(NSPasteboard.self) { _ in
            NSPasteboard.general
        }
    }
}
