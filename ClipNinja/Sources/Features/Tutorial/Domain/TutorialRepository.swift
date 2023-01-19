import Foundation

protocol TutorialRepository {
    var currentTutorial: Tutorial? { get }
    func checkTutorials(for event: TutorialTriggeringEvent)
    func finishCurrentTutorial()
}

final class TutorialRepositoryImpl: TutorialRepository {

    private let tutorialResource: TutorialResource

    private(set) var currentTutorial: Tutorial?

    init(tutorialResource: TutorialResource) {
        self.tutorialResource = tutorialResource
    }

    func checkTutorials(for event: TutorialTriggeringEvent) {
        if !tutorialResource.userOnboard {
            currentTutorial = .welcome
        } else {
            currentTutorial = nil
        }
    }

    func finishCurrentTutorial() {
        
    }
}
