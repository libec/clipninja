import Swinject
import SwinjectAutoregistration
import SwiftUI

public enum AssemblyKeys: String {
    case clipboardView
}

struct ClipboardFeatureAssembly: Assembly {

    init() { }
    
    func assemble(container: Container) {
        container.register(AnyView.self, name: AssemblyKeys.clipboardView.rawValue) { resolver in
            return AnyView(
                resolver.resolve(ClipboardView<ClipboardViewModelImpl>.self)!
            )
        }
        container.autoregister(ClipboardViewModelImpl.self, initializer: ClipboardViewModelImpl.init).implements((any ClipboardViewModel).self)
        container.autoregister(ClipboardView<ClipboardViewModelImpl>.self, initializer: ClipboardView.init)
        container.autoregister(ClipboardPreviewFactory.self, initializer: ClipboardPreviewFactoryImpl.init)
        container.autoregister(Clipboards.self, initializer: ClipboardsFacade.init)
        container.autoregister(MoveViewPortUseCase.self, initializer: MoveViewPortUseCaseImpl.init)
        container.autoregister(GetViewPortUseCase.self, initializer: GetViewPortUseCaseImpl.init)
        container.autoregister(PasteUseCase.self, initializer: PasteUseCaseImpl.init)
        container.autoregister(ClipsRepository.self, initializer: InMemoryClipboardsRepository.init)
        container.autoregister(ViewPortConfiguration.self, initializer: DefaultViewPortConfiguration.init).inObjectScope(.container)
    }
}

