import Combine

struct ClipboardViewPort {
    let clips: [Clip]
    let selectedPage: Int
    let numberOfPages: Int
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
