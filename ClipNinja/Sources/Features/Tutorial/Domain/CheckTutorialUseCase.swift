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
    func check(for prompt: TutorialPrompt)
}

final class CheckTutorialUseCaseImpl: CheckTutorialUseCase {
    func check(for prompt: TutorialPrompt) {
        log(message: "Prompt: \(prompt.logDescription)", category: .tutorial)
    }
}
