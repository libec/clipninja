@testable import ClipNinjaPackage
import XCTest
import Combine

class SettingsViewModelTests: XCTestCase {

    func test_it_notifies_about_new_settings() {
        var subscriptions = Set<AnyCancellable>()
        let getSettingsUseCase = GetSettingsUseCaseStub(
            storedSettings: Settings(
                pasteDirectly: true,
                launchAtLogin: false
            )
        )
        let sut = SettingsViewModelImpl(
            togglePasteDirectlyUseCase: TogglePasteDirectlyUseCaseDummy(),
            toggleLaunchAtLoginUseCase: ToggleLaunchAtLoginUseCaseDummy(),
            getSettingsUseCase: getSettingsUseCase
        )

        sut.onEvent(.lifecycle(.appear))

        sut.$pasteDirectly.sink { allowedToPaste in
            XCTAssertEqual(allowedToPaste, true)
        }.store(in: &subscriptions)

        sut.$launchAtLogin.sink { launchAtLogin in
            XCTAssertEqual(launchAtLogin, false)
        }.store(in: &subscriptions)
    }

    func test_it_toggles_paste_directly() {
        let togglePasteDirectlyUseCase = TogglePasteDirectlyUseCaseSpy()
        let sut = SettingsViewModelImpl(
            togglePasteDirectlyUseCase: togglePasteDirectlyUseCase,
            toggleLaunchAtLoginUseCase: ToggleLaunchAtLoginUseCaseDummy(),
            getSettingsUseCase: GetSettingsUseCaseStub(storedSettings: Settings.default)
        )
        sut.onEvent(.settingsEvent(.togglePasteDirectly))

        try XCTAssertTrue(XCTUnwrap(togglePasteDirectlyUseCase.toggleCalled))
    }

    func test_it_toggles_launch_at_login() {
        let toggleLaunchAtLoginUseCase = ToggleLaunchAtLoginUseCaseSpy()
        let sut = SettingsViewModelImpl(
            togglePasteDirectlyUseCase: TogglePasteDirectlyUseCaseDummy(),
            toggleLaunchAtLoginUseCase: toggleLaunchAtLoginUseCase,
            getSettingsUseCase: GetSettingsUseCaseStub(storedSettings: Settings.default)
        )
        sut.onEvent(.settingsEvent(.toggleLaunchAtLogin))

        try XCTAssertTrue(XCTUnwrap(toggleLaunchAtLoginUseCase.toggleCalled))
    }
}

class GetSettingsUseCaseStub: GetSettingsUseCase {

    private let storedSettings: Settings

    init(storedSettings: Settings) {
        self.storedSettings = storedSettings
    }

    var settings: AnyPublisher<Settings, Never> {
        return Just(storedSettings)
            .eraseToAnyPublisher()
    }
}

typealias ToggleLaunchAtLoginUseCaseDummy = ToggleLaunchAtLoginUseCaseSpy
class ToggleLaunchAtLoginUseCaseSpy: ToggleLaunchAtLoginUseCase {

    var toggleCalled: Bool?

    func toggle() {
        toggleCalled = true
    }
}

typealias TogglePasteDirectlyUseCaseDummy = TogglePasteDirectlyUseCaseSpy
class TogglePasteDirectlyUseCaseSpy: TogglePasteDirectlyUseCase {

    var toggleCalled: Bool?

    func toggle() {
        toggleCalled = true
    }
}
