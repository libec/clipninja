import Combine

struct ClipboardViewPort {
    let clips: [Clip]
    let selectedClipIndex: Int
    let selectedPage: Int
    let numberOfPages: Int
}

protocol GetClipsViewPortUseCase {
    var clipsViewPort: AnyPublisher<ClipboardViewPort, Never> { get }
}

final class GetClipsViewPortUseCaseImpl: GetClipsViewPortUseCase {

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

    var clipsViewPort: AnyPublisher<ClipboardViewPort, Never> {
        clipsRepositorty.clips.combineLatest(viewPortRepository.position)
            .map { (clips, selectedClipIndex) in
                let clipsPerPage = self.viewPortConfiguration.clipsPerPage
                let clipsRemainder = clips.count % clipsPerPage
                let numberOfPages = (clips.count / clipsPerPage) + (clipsRemainder == 0 ? 0 : 1)
                let selectedPage = selectedClipIndex / clipsPerPage
                let selectedIndexRemainder = selectedClipIndex % clipsPerPage
                let clipsLowerBound = selectedPage * clipsPerPage
                let clipsUpperBound = min((selectedPage + 1) * clipsPerPage, clips.count)
                let clipsInRange = clips[clipsLowerBound..<clipsUpperBound]

                log(message: "Clips: (\(clipsLowerBound)..<\(clipsUpperBound), selectedIndex: \(selectedIndexRemainder)")
                log(message: "Pages: (\(selectedPage)/\(numberOfPages))")

                return ClipboardViewPort(
                    clips: Array(clipsInRange),
                    selectedClipIndex: selectedIndexRemainder,
                    selectedPage: selectedPage,
                    numberOfPages: numberOfPages
                )
            }
            .eraseToAnyPublisher()

    }
}
