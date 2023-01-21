import Foundation

protocol TutorialRepository {
    var currentTutorial: Tutorial? { get }
    func checkTutorials(for event: TutorialTriggeringEvent)
    func finishCurrentTutorial()
}

final class TutorialRepositoryImpl: TutorialRepository {

    private let resource: TutorialResource

    private(set) var currentTutorial: Tutorial?

    init(resource: TutorialResource) {
        self.resource = resource
    }

    func checkTutorials(for event: TutorialTriggeringEvent) {
        switch event {
        case .clipsAppear:
            if !resource.contains(flag: .onboard) {
                currentTutorial = .welcome
            }
        case .clipsMovement:
            break
        case .pasteText:
            if !resource.contains(flag: .pasteText) {
                currentTutorial = .pasting
            }
        }
    }

    func finishCurrentTutorial() {
        switch currentTutorial {
        case .welcome:
            resource.set(flag: .onboard)
        case .pasting:
            resource.set(flag: .pasteText)
        case .none:
            break
        }
        currentTutorial = nil
    }
}
