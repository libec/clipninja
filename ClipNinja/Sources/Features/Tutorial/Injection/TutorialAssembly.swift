import SwiftUI
import Swinject
import SwinjectAutoregistration

struct TutorialAssembly: Assembly {
    init() {}

    func assemble(container: Container) {
        container.register(AnyView.self, name: AssemblyKeys.tutorialView.rawValue) { resolver in
            AnyView(
                resolver.resolve(TutorialView<TutorialViewModelImpl>.self)!
            )
        }
        container.register(TutorialView<TutorialViewModelImpl>.self) { resolver in
            TutorialView<TutorialViewModelImpl>(
                viewModel: resolver.resolve(TutorialViewModelImpl.self)!
            )
        }
        container.autoregister(TutorialViewModelImpl.self, initializer: TutorialViewModelImpl.init)
            .implements((any TutorialViewModel).self)

        container.autoregister(CheckTutorialUseCase.self, initializer: CheckTutorialUseCaseImpl.init)
        container.autoregister(CurrentTutorialUseCase.self, initializer: CurrentTutorialUseCaseImpl.init)
        container.autoregister(FinishCurrentTutorialUseCase.self, initializer: FinishCurrentTutorialUseCaseImpl.init)
        container.autoregister(TutorialRepository.self, initializer: TutorialRepositoryImpl.init)
            .inObjectScope(.container)
        container.autoregister(Tutorials.self, initializer: TutorialsFacade.init)

//        container.autoregister(TutorialResource.self, initializer: LocalTutorialResource.init)
        container.autoregister(TutorialResource.self, initializer: UserDefaultsTutorialResource.init)
    }
}
