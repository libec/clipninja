import Combine

protocol TutorialViewModel: ObservableObject {
    func onEvent(_ event: TutorialEvent)
}

enum TutorialEvent {
    case lifecycle(LifecycleEvent)
    case onboarding(TutorialEvent)

    enum TutorialEvent {
        case dismiss
    }
}
