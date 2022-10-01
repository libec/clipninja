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
            .map { (clips, selectedClipIndex) in
                let clipsPerPage = self.viewPortConfiguration.clipsPerPage
                let clipsRemainder = clips.count % clipsPerPage
                let numberOfPages = (clips.count / clipsPerPage) + (clipsRemainder == 0 ? 0 : 1)
                let selectedPage = selectedClipIndex / clipsPerPage
                let selectedIndexRemainder = selectedClipIndex % clipsPerPage
                let clipsLowerBound = selectedPage * clipsPerPage
                let clipsUpperBound = min((selectedPage + 1) * clipsPerPage, clips.count - 1)
                let clipsInRange = clips[clipsLowerBound...clipsUpperBound]
                return ClipboardViewPort(
                    clips: clipsInRange.enumerated().map { (index, clip) in
                        Clip(text: clip.text, pinned: clip.pinned, selected: index == selectedIndexRemainder)
                    },
                    selectedPage: selectedPage,
                    numberOfPages: numberOfPages
                )
            }
            .eraseToAnyPublisher()

    }
}
