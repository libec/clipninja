protocol FinishCurrentTutorialUseCase {
    func finish()
}

final class FinishCurrentTutorialUseCaseImpl: FinishCurrentTutorialUseCase {

    private let repository: TutorialRepository

    init(repository: TutorialRepository) {
        self.repository = repository
    }

    func finish() {
        repository.finishCurrentTutorial()
    }
}
