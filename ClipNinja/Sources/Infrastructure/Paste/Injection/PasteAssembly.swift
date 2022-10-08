import AppKit
import Swinject
import SwinjectAutoregistration

struct PasteAssembly: Assembly {
    
    init() { }

    func assemble(container: Container) {
        container.autoregister(PasteCommand.self, initializer: SystemPasteCommand.init)
        container.autoregister(PasteTextUseCase.self, initializer: PasteTextUseCaseImpl.init)
        container.autoregister(PasteboardService.self, initializer: SystemPaseboardService.init)
        container.register(NSPasteboard.self) { _ in
            NSPasteboard.general
        }
    }
}
