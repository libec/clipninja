public protocol ResetViewPortUseCase {
    func reset()
}

final class ResetViewPortUseCaseImpl: ResetViewPortUseCase {
    private let viewPortRepository: ViewPortRepository

    init(
        viewPortRepository: ViewPortRepository
    ) {
        self.viewPortRepository = viewPortRepository
    }

    func reset() {
        viewPortRepository.update(position: 0)
    }
}
