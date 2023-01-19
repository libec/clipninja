import Combine

protocol TutorialViewModel: ObservableObject {
    var tutorial: Tutorial? { get }
    func onEvent(_ event: TutorialEvent)
}

enum TutorialEvent {
    case lifecycle(LifecycleEvent)
    case tutorial(TutorialEvent)

    enum TutorialEvent {
        case dismiss
    }
}

final class TutorialViewModelImpl: TutorialViewModel {

    private let tutorials: Tutorials
    @Published var tutorial: Tutorial?

    init(tutorials: Tutorials) {
        self.tutorials = tutorials
    }

    func onEvent(_ event: TutorialEvent) {
        switch event {
        case .lifecycle(.appear):
            tutorial = tutorials.getCurrent()
        case .tutorial(.dismiss):
            tutorials.finish()
        }
    }
}
