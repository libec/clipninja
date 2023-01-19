protocol FinishCurrentTutorialUseCase {
    func finish()
}

final class FinishCurrentTutorialUseCaseImpl: FinishCurrentTutorialUseCase {

    private let repository: TutorialRepository
    private let navigation: Navigation

    init(repository: TutorialRepository, navigation: Navigation) {
        self.repository = repository
        self.navigation = navigation
    }

    func finish() {
        repository.finishCurrentTutorial()
        navigation.handle(navigationEvent: .hideTutorial)
    }
}
