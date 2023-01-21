import Swinject
import SwinjectAutoregistration
import SwiftUI

struct ClipboardAssembly: Assembly {

    init() { }
    
    func assemble(container: Container) {
        assembleViews(container: container)
        assembleDomain(container: container)
        assembleSystem(container: container)
    }

    func assembleViews(container: Container) {
        container.register(AnyView.self, name: AssemblyKeys.clipboardView.rawValue) { resolver in
            return AnyView(
                resolver.resolve(ClipboardView<ClipboardViewModelImpl>.self)!
            )
        }
        container.autoregister(ClipboardViewModelImpl.self, initializer: ClipboardViewModelImpl.init).implements((any ClipboardViewModel).self)
        container.autoregister(ClipboardView<ClipboardViewModelImpl>.self, initializer: ClipboardView.init)
        container.autoregister(ClipboardPreviewFactory.self, initializer: ClipboardPreviewFactoryImpl.init)
    }

    func assembleDomain(container: Container) {
        container.autoregister(Clipboards.self, initializer: ClipboardsFacade.init)
        container.autoregister(GetClipsViewPortUseCase.self, initializer: GetClipsViewPortUseCaseImpl.init)
        container.autoregister(PasteUseCase.self, initializer: PasteUseCaseImpl.init)
        container.autoregister(DeleteUseCase.self, initializer: DeleteUseCaseImpl.init)
        container.autoregister(PinUseCase.self, initializer: PinUseCaseImpl.init)
        container.autoregister(MoveViewPortUseCase.self, initializer: MoveViewPortUseCaseImpl.init)
        container.autoregister(ViewPortConfiguration.self, initializer: DefaultViewPortConfiguration.init).inObjectScope(.container)
    }

    func assembleSystem(container: Container) {
        container.register(ClipsRepository.self) { resolver in
            ClipsRepositoryImpl(
                pasteboardObserver: resolver.resolve(PasteboardObserver.self)!,
                clipsResource: resolver.resolve(ClipsResource.self)!,
                viewPortConfiguration: resolver.resolve(ViewPortConfiguration.self)!,
                storageScheduler: RunLoop.main
            )
        }
        .inObjectScope(.container)
        container.autoregister(ClipsResource.self, initializer: ProtectedLocalClipsResource.init)
        container.register(FileManager.self) { _ in FileManager.default }.inObjectScope(.container)
    }
}
