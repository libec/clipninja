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
    private let viewPortConfiguration: ViewPortConfiguration

    init( 
        clipsRepositorty: ClipsRepository,
        viewPortRepository: ViewPortRepository,
        viewPortConfiguration: ViewPortConfiguration
    ) {
        self.clipsRepositorty = clipsRepositorty
        self.viewPortRepository = viewPortRepository
        self.viewPortConfiguration = viewPortConfiguration
    }

    var clips: AnyPublisher<ClipboardViewPort, Never> {
        clipsRepositorty.clips.combineLatest(viewPortRepository.position)
            .map { (clips, viewPort) in
                let clipsRemainder = clips.count % self.viewPortConfiguration.clipsPerPage
                let numberOfPages = (clips.count / self.viewPortConfiguration.clipsPerPage) + (clipsRemainder == 0 ? 0 : 1)
                let selectedPage = viewPort / self.viewPortConfiguration.clipsPerPage
                let viewPortRemainder = viewPort % self.viewPortConfiguration.clipsPerPage
                let clipsLowerBound = selectedPage * self.viewPortConfiguration.clipsPerPage
                let clipsUpperBound = min((selectedPage + 1) * self.viewPortConfiguration.clipsPerPage, clips.count - 1)
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
