enum TutorialTriggeringEvent: CaseIterable {
    case clipsAppear
    case clipsMovement
    case pasteText

    fileprivate var eventDescription: String {
        switch self {
        case .clipsAppear: return "Clips appeared"
        case .clipsMovement: return "Clips movement event"
        case .pasteText: return "Paste text"
        }
    }

    fileprivate var logDescription: String {
        "tutorial event: \(eventDescription)"
    }
}

enum Tutorial: CaseIterable {
    case welcome
    case pasting
}

protocol CheckTutorialUseCase {
    func checkTutorials(for event: TutorialTriggeringEvent)
}

final class CheckTutorialUseCaseImpl: CheckTutorialUseCase {

    private let tutorialRepository: TutorialRepository
    private let navigation: Navigation

    init(tutorialRepository: TutorialRepository, navigation: Navigation) {
        self.tutorialRepository = tutorialRepository
        self.navigation = navigation
    }

    func checkTutorials(for event: TutorialTriggeringEvent) {
        log(message: "Prompt: \(event.logDescription)", category: .tutorial)
        tutorialRepository.checkTutorials(for: event)
        if tutorialRepository.currentTutorial != nil {
            navigation.handle(navigationEvent: .showTutorial)
        }
    }
}
