protocol TutorialRepository {
    func checkTutorials(for event: TutorialTriggeringEvent) -> Tutorial?
}

final class TutorialRepositoryImpl: TutorialRepository {

    private let tutorialResource: TutorialResource

    init(tutorialResource: TutorialResource) {
        self.tutorialResource = tutorialResource
    }

    func checkTutorials(for event: TutorialTriggeringEvent) -> Tutorial? {
        nil
    }
}
