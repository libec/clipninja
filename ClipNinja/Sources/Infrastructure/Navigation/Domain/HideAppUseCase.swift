protocol HideAppUseCase {
    func hide()
}

final class HideAppUseCaseImpl: HideAppUseCase {

    private let navigation: Navigation
    private let viewPortRepository: ViewPortRepository

    init(
        navigation: Navigation,
        viewPortRepository: ViewPortRepository
    ) {
        self.navigation = navigation
        self.viewPortRepository = viewPortRepository
    }

    func hide() {
        navigation.hide()
        viewPortRepository.update(position: 0)
    }
}
