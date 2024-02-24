@testable import ClipNinjaPackage
import XCTest
import Combine

class SettingsViewModelTests: XCTestCase {

    func test_it_notifies_about_new_settings() {
        let getSettingsUseCase = GetSettingsUseCaseStub(
            storedSettings: Settings(
                pasteDirectly: true,
                launchAtLogin: false,
                movePastedClipToTop: false
            )
        )
        let sut = SettingsViewModelImpl(
            toggleSettingsUseCase: ToggleSettingsUseCaseDummy(),
            getSettingsUseCase: getSettingsUseCase,
            navigation: NavigationDummy()
        )

        sut.onEvent(.lifecycle(.appear))

        XCTAssertEqual(sut.pasteDirectly, true)
        XCTAssertEqual(sut.launchAtLogin, false)
        XCTAssertEqual(sut.movePastedClipToTop, false)
    }

    func test_it_toggles_paste_directly() {
        let toggleSettingsUseCase = ToggleSettingsUseCaseSpy()
        let sut = SettingsViewModelImpl(
            toggleSettingsUseCase: toggleSettingsUseCase,
            getSettingsUseCase: GetSettingsUseCaseStub(storedSettings: .default),
            navigation: NavigationDummy()
        )
        sut.onEvent(.settingsEvent(.togglePasteDirectly))

        try XCTAssertEqual(XCTUnwrap(toggleSettingsUseCase.toggledSetting), .pasteDirectly)
    }

    func test_it_toggles_move_pasted_clip_to_top() {
        let toggleSettingsUseCase = ToggleSettingsUseCaseSpy()
        let sut = SettingsViewModelImpl(
            toggleSettingsUseCase: toggleSettingsUseCase,
            getSettingsUseCase: GetSettingsUseCaseStub(storedSettings: .default),
            navigation: NavigationDummy()
        )
        sut.onEvent(.settingsEvent(.toggleMovePastedToTop))

        try XCTAssertEqual(XCTUnwrap(toggleSettingsUseCase.toggledSetting), .movePastedClipToTop)
    }

    func test_it_toggles_launch_at_login() {
        let toggleSettingsUseCase = ToggleSettingsUseCaseSpy()
        let sut = SettingsViewModelImpl(
            toggleSettingsUseCase: toggleSettingsUseCase,
            getSettingsUseCase: GetSettingsUseCaseStub(storedSettings: .default),
            navigation: NavigationDummy()
        )
        sut.onEvent(.settingsEvent(.toggleLaunchAtLogin))

        try XCTAssertEqual(XCTUnwrap(toggleSettingsUseCase.toggledSetting), .launchAtLogin)
    }

    func test_it_shows_paste_directly_hint_on_paste_directly_event() {
        let sut = SettingsViewModelImpl(
            toggleSettingsUseCase: ToggleSettingsUseCaseDummy(),
            getSettingsUseCase: GetSettingsUseCaseStub(storedSettings: .default),
            navigation: NavigationDummy()
        )

        sut.onEvent(.settingsEvent(.showPasteDirectlyHint))

        XCTAssertEqual(sut.showPasteDirectlyHint, true)
    }

    func test_it_hides_paste_directly_hint_on_paste_directly_event_when_already_shown() {
        let sut = SettingsViewModelImpl(
            toggleSettingsUseCase: ToggleSettingsUseCaseDummy(),
            getSettingsUseCase: GetSettingsUseCaseStub(storedSettings: .default),
            navigation: NavigationDummy()
        )
        sut.onEvent(.settingsEvent(.showPasteDirectlyHint))

        sut.onEvent(.settingsEvent(.showPasteDirectlyHint))

        XCTAssertEqual(sut.showPasteDirectlyHint, false)
    }

    func test_it_shows_paste_directly_hint_when_toggling_paste_directly_returns_error() {
        let toggleSettingsUseCase = ToggleSettingsUseCaseStub(result: .failure(.permissionNotGranted))
        let sut = SettingsViewModelImpl(
            toggleSettingsUseCase: toggleSettingsUseCase,
            getSettingsUseCase: GetSettingsUseCaseStub(storedSettings: .default),
            navigation: NavigationDummy()
        )

        sut.onEvent(.settingsEvent(.togglePasteDirectly))

        XCTAssertEqual(sut.showPasteDirectlyHint, true)
    }

    func test_it_passes_navigation_events() {
        let navigation = NavigationSpy()
        let sut = SettingsViewModelImpl(
            toggleSettingsUseCase: ToggleSettingsUseCaseDummy(),
            getSettingsUseCase: GetSettingsUseCaseDummy(),
            navigation: navigation
        )

        sut.onEvent(.settingsEvent(.showAccessibilitySettings))
        XCTAssertEqual(navigation.handledEvent, .showSystemSettings)
    }
}

class GetSettingsUseCaseDummy: GetSettingsUseCase {
    var settings: AnyPublisher<Settings, Never> {
        Just(Settings(pasteDirectly: false, launchAtLogin: false, movePastedClipToTop: true))
            .eraseToAnyPublisher()
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

    func toggle(setting: ToggleSetting) -> Result<Void, ToggleSettingsError> {
        toggledSetting = setting
        return .success(())
    }
}

class ToggleSettingsUseCaseStub: ToggleSettingsUseCase {
    let result: Result<Void, ToggleSettingsError>

    init(result: Result<Void, ToggleSettingsError>) {
        self.result = result
    }

    func toggle(setting: ToggleSetting) -> Result<Void, ToggleSettingsError> {
        result
    }
}
