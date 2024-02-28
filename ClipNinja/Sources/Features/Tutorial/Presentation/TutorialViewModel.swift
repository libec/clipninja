import Combine

protocol TutorialViewModel: ObservableObject {
    var tutorial: Tutorial? { get }
    var showSettings: Bool { get }
    func onEvent(_ event: TutorialEvent)
}

enum TutorialEvent {
    case lifecycle(LifecycleEvent)
    case tutorial(TutorialEvent)

    enum TutorialEvent {
        case showAppSettings
        case dismiss
    }
}

final class TutorialViewModelImpl: TutorialViewModel {
    private let tutorials: Tutorials
    private let navigation: Navigation
    @Published var tutorial: Tutorial?
    @Published var showSettings: Bool = false

    init(tutorials: Tutorials, navigation: Navigation) {
        self.tutorials = tutorials
        self.navigation = navigation
    }

    func onEvent(_ event: TutorialEvent) {
        switch event {
        case .lifecycle(.appear):
            tutorial = tutorials.getCurrent()
            showSettings = tutorial == .pasting
        case .tutorial(.dismiss):
            tutorials.finish()
        case .tutorial(.showAppSettings):
            navigation.handle(navigationEvent: .hideTutorial)
            navigation.handle(navigationEvent: .showSettings)
            tutorials.finish()
        }
    }
}
