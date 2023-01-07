import Combine

struct DescriptiveText: Identifiable, Hashable {
    var id: String { description }

    let prominent: Bool
    let description: String
}

protocol OnboardingViewModel: ObservableObject {
    var title: String { get }
    var descriptions: [[DescriptiveText]] { get }

    func onEvent(_ event: OnboardingEvent)
}

enum OnboardingEvent {
    case lifecycle(LifecycleEvent)
    case onboarding(Onboarding)

    enum Onboarding {
        case `try`
        case skipOnboarding
    }
}
