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
        clipsRepository.delete(at: index)
        let newIndex = max(min(clipsRepository.lastClips.count - 1, index), 0)
        viewPortRepository.update(position:  newIndex)
    }
}
