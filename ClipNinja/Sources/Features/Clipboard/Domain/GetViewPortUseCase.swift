import Combine

struct ClipboardViewPort {
    let clips: [Clip]
    let selectedTab: Int
    let numberOfTabs: Int
}

protocol GetViewPortUseCase {
    var clips: AnyPublisher<ClipboardViewPort, Never> { get }
}

final class GetViewPortUseCaseImpl: GetViewPortUseCase {

    var clips: AnyPublisher<ClipboardViewPort, Never> {
        Empty()
            .eraseToAnyPublisher()
    }
}
