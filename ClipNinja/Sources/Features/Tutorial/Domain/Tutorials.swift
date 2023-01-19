protocol Tutorials: CurrentTutorialUseCase, FinishCurrentTutorialUseCase, CheckTutorialUseCase { }

class TutorialsFacade: Tutorials {

    let currentTutorialUseCase: CurrentTutorialUseCase
    let finishCurrentTutorialUseCase: FinishCurrentTutorialUseCase
    let checkTutorialUseCase: CheckTutorialUseCase

    init(
        currentTutorialUseCase: CurrentTutorialUseCase,
        finishCurrentTutorialUseCase: FinishCurrentTutorialUseCase,
        checkTutorialUseCase: CheckTutorialUseCase
    ) {
        self.currentTutorialUseCase = currentTutorialUseCase
        self.finishCurrentTutorialUseCase = finishCurrentTutorialUseCase
        self.checkTutorialUseCase = checkTutorialUseCase
    }

    func getCurrent() -> Tutorial? {
        currentTutorialUseCase.getCurrent()
    }

    func finish() {
        finishCurrentTutorialUseCase.finish()
    }

    func checkTutorials(for event: TutorialTriggeringEvent) {
        checkTutorialUseCase.checkTutorials(for: event)
    }
}
