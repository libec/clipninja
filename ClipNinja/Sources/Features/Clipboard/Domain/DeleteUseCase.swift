protocol DeleteUseCase {
    func delete()
}

final class DeleteUseCaseImpl: DeleteUseCase {

    private let viewPortRepository: ViewPortRepository
    private let clipsRepository: ClipsRepository

    init(
        viewPortRepository: ViewPortRepository,
        clipsRepository: ClipsRepository
    ) {
        self.viewPortRepository = viewPortRepository
        self.clipsRepository = clipsRepository
    }

    func delete() {
        let index = viewPortRepository.lastPosition
        let shouldDecrementViewPort = index >= clipsRepository.lastClips.count - 1
        clipsRepository.delete(at: index)
        if shouldDecrementViewPort {
            viewPortRepository.update(position: max(index - 1, 0))
        }

    }
}
