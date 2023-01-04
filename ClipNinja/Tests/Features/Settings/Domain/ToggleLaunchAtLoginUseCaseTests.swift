import XCTest
@testable import ClipNinjaPackage

class ToggleSettingsUseCaseTests: XCTestCase {

    func test_it_toggles_launch_at_login_setting() {
        let settingsRepository = SettingsRepositorySpy()
        let sut = ToggleSettingsUseCaseImpl(settingsRepository: settingsRepository)

        sut.toggle(setting: .launchAtLogin)

        try XCTAssertTrue(XCTUnwrap(settingsRepository.toggleLaunchAtLoginCalled))
    }

    func test_it_toggles_paste_directly_setting() {
        let settingsRepository = SettingsRepositorySpy()
        let sut = ToggleSettingsUseCaseImpl(settingsRepository: settingsRepository)

        sut.toggle(setting: .pasteDirectly)

        try XCTAssertTrue(XCTUnwrap(settingsRepository.togglePasteDirectlyCalled))
    }

}
