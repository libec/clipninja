protocol PinUseCase {
    func pin()
}

final class PinUseCaseImpl: PinUseCase {

    private let clipsRepository: ClipsRepository
    private let viewPortRepository: ViewPortRepository

    init(
        clipsRepository: ClipsRepository,
        viewPortRepository: ViewPortRepository
    ) {
        self.clipsRepository = clipsRepository
        self.viewPortRepository = viewPortRepository
    }

    func pin() {
        // TODO: - check index in array just in case
        let isPinnned = clipsRepository.lastClips[viewPortRepository.lastPosition].pinned
        let numberOfPinned = clipsRepository.lastClips.filter(\.pinned).count
        let newViewPortIndex = isPinnned ? numberOfPinned - 1 : numberOfPinned
        clipsRepository.togglePin(at: viewPortRepository.lastPosition)
        viewPortRepository.update(position: newViewPortIndex)
    }
}
