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

    private let clipsRepositorty: ClipsRepository
    private let viewPortRepository: ViewPortRepository

    init(
        clipsRepositorty: ClipsRepository,
        viewPortRepository: ViewPortRepository
    ) {
        self.clipsRepositorty = clipsRepositorty
        self.viewPortRepository = viewPortRepository
    }

    var clips: AnyPublisher<ClipboardViewPort, Never> {
        clipsRepositorty.clips.combineLatest(viewPortRepository.position)
            .map { (clips, viewPort) in
                let clipsRemainder = clips.count % ViewPortConfiguration.clipsPerPage
                let numberOfPages = (clips.count / ViewPortConfiguration.clipsPerPage) + (clipsRemainder == 0 ? 0 : 1)
                let selectedPage = viewPort / ViewPortConfiguration.clipsPerPage
                let viewPortRemainder = viewPort % ViewPortConfiguration.clipsPerPage
                let clipsLowerBound = selectedPage * ViewPortConfiguration.clipsPerPage
                let clipsUpperBound = min((selectedPage + 1) * ViewPortConfiguration.clipsPerPage, clips.count - 1)
                let clipsInRange = clips[clipsLowerBound...clipsUpperBound]
                return ClipboardViewPort(
                    clips: clipsInRange.enumerated().map { (index, clip) in
                        return Clip(text: clip.text, pinned: clip.pinned, selected: index == viewPortRemainder)
                    },
                    selectedPage: selectedPage,
                    numberOfPages: numberOfPages
                )
            }
            .eraseToAnyPublisher()

    }
}
