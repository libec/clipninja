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
        switch event {
        case .clipsAppear:
            if !tutorialResource.contains(flag: .onboard) {
                currentTutorial = .welcome
            }
        case .clipsMovement:
            break
        case .pasteText:
            break
        }
    }

    func finishCurrentTutorial() {
        switch currentTutorial {
        case .welcome:
            tutorialResource.set(flag: .onboard)
        case .pasting:
            break
        case .none:
            break
        }
        currentTutorial = nil
    }
}
