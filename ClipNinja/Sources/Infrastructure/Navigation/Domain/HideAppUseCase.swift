protocol HideAppUseCase {
    func hide()
}

final class HideAppUseCaseImpl: HideAppUseCase {

    private let navigation: Navigation

    init(navigation: Navigation) {
        self.navigation = navigation
    }

    func hide() {
        navigation.hide()
    }
}
