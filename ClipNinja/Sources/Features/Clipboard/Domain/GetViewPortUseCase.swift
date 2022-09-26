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

    let repository: ClipsRepository

    init(repository: ClipsRepository) {
        self.repository = repository
    }

    var clips: AnyPublisher<ClipboardViewPort, Never> {
        repository.clips
            .map {
                ClipboardViewPort(
                    clips: $0.map { Clip(text: $0.text, pinned: $0.pinned, selected: false) },
                    selectedPage: 0,
                    numberOfPages: 3)
            }
            .eraseToAnyPublisher()
    }
}
