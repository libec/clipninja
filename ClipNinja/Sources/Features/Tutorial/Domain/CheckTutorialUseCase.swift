enum TutorialPrompt {
    case clipsAppear
    case user

    fileprivate var logDescription: String {
        switch self {
        case .clipsAppear: return "Clips Appeared"
        case .user: return "User Prompt"
        }
    }
}

protocol CheckTutorialUseCase {
    func check(with prompt: TutorialPrompt)
}

protocol TutorialRepository {
    func check(with prompt: TutorialPrompt)
}

protocol TutorialResource {
    func alreadyWentThroughTutorial() -> Bool
}

final class CheckTutorialUseCaseImpl: CheckTutorialUseCase {

    private let tutorialRepository: TutorialRepository
    private let navigation: Navigation

    init(tutorialRepository: TutorialRepository, navigation: Navigation) {
        self.tutorialRepository = tutorialRepository
        self.navigation = navigation
    }

    func check(with prompt: TutorialPrompt) {
        log(message: "Prompt: \(prompt.logDescription)", category: .tutorial)
        navigation.handle(navigationEvent: .showTutorialOnClips)
    }
}

final class TutorialRepositoryImpl: TutorialRepository {

    private let tutorialResource: TutorialResource

    init(tutorialResource: TutorialResource) {
        self.tutorialResource = tutorialResource
    }

    func check(with prompt: TutorialPrompt) {

    }
}
