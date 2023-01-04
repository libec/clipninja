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
            toggleSettingsUseCase: ToggleSettingsUseCaseDummy(),
            getSettingsUseCase: getSettingsUseCase
        )

        sut.onEvent(.lifecycle(.appear))

        sut.$pasteDirectly.sink { pasteDirectlySetting in
            XCTAssertEqual(pasteDirectlySetting, true)
        }.store(in: &subscriptions)

        sut.$launchAtLogin.sink { launchAtLogin in
            XCTAssertEqual(launchAtLogin, false)
        }.store(in: &subscriptions)
    }

    func test_it_toggles_paste_directly() {
        let toggleSettingsUseCase = ToggleSettingsUseCaseSpy()
        let sut = SettingsViewModelImpl(
            toggleSettingsUseCase: toggleSettingsUseCase,
            getSettingsUseCase: GetSettingsUseCaseStub(storedSettings: Settings.default)
        )
        sut.onEvent(.settingsEvent(.togglePasteDirectly))

        try XCTAssertEqual(XCTUnwrap(toggleSettingsUseCase.toggledSetting), .pasteDirectly)
    }

    func test_it_toggles_launch_at_login() {
        let toggleSettingsUseCase = ToggleSettingsUseCaseSpy()
        let sut = SettingsViewModelImpl(
            toggleSettingsUseCase: toggleSettingsUseCase,
            getSettingsUseCase: GetSettingsUseCaseStub(storedSettings: Settings.default)
        )
        sut.onEvent(.settingsEvent(.toggleLaunchAtLogin))

        try XCTAssertEqual(XCTUnwrap(toggleSettingsUseCase.toggledSetting), .launchAtLogin)
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

typealias ToggleSettingsUseCaseDummy = ToggleSettingsUseCaseSpy
class ToggleSettingsUseCaseSpy: ToggleSettingsUseCase {

    var toggledSetting: ToggleSetting?

    func toggle(setting: ToggleSetting) {
        toggledSetting = setting
    }
}
