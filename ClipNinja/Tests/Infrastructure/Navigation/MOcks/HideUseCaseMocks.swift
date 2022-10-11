@testable import ClipNinja

typealias HideAppUseCaseDummy = HideAppUseCaseSpy
class HideAppUseCaseSpy: HideAppUseCase {

    var hideCalled: Bool?

    func hide() {
        hideCalled = true
    }
}
