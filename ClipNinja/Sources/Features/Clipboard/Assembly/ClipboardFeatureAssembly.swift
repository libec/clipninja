import Swinject
import SwinjectAutoregistration
import SwiftUI

struct ClipboardFeatureAssembly: Assembly {

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
        container.autoregister(ClipsRepository.self, initializer: ClipsRepositoryImpl.init)
        container.autoregister(ClipsStorage.self, initializer: UserDefaultsClipsStorage.init)
    }
}
