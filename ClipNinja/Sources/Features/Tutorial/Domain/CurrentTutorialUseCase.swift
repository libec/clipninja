protocol CurrentTutorialUseCase {
    func getCurrent() -> Tutorial?
}

final class CurrentTutorialUseCaseImpl: CurrentTutorialUseCase {

    private let repository: TutorialRepository

    init(repository: TutorialRepository) {
        self.repository = repository
    }

    func getCurrent() -> Tutorial? {
        repository.currentTutorial
    }
}
