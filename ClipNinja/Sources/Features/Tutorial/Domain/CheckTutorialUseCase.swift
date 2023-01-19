enum TutorialTriggeringEvent: CaseIterable {
    case clipsAppear
    case pasteText

    fileprivate var logDescription: String {
        switch self {
        case .clipsAppear: return "Clips appeared"
        case .pasteText: return "Paste text"
        }
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
