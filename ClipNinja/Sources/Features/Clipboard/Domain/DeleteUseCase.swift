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
        viewPortRepository.update(position: max(index - 1, 0))
    }
}
