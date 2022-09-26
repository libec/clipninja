import Swinject
import SwinjectAutoregistration

struct ClipboardAssembly: Assembly {

    init() { }
    
    func assemble(container: Container) {
        container.autoregister(ClipboardView.self, initializer: ClipboardView.init)
        container.autoregister((any ClipboardViewModel).self, initializer: ClipboardViewModelImpl.init)
        container.autoregister(ClipboardPreviewFactory.self, initializer: ClipboardPreviewFactoryImpl.init)
        container.autoregister(Clipboards.self, initializer: ClipboardsFacade.init)
        container.autoregister(MoveViewPortUseCase.self, initializer: MoveViewPortUseCaseImpl.init)
        container.autoregister(GetViewPortUseCase.self, initializer: GetViewPortUseCaseImpl.init)
        container.autoregister(ViewPortRepository.self, initializer: InMemoryViewPortRepository.init)
        container.autoregister(ClipsRepository.self, initializer: InMemoryClipboardsRepository.init)
    }
}
