import XCTest
@testable import ClipNinjaPackage

class ToggleSettingsUseCaseTests: XCTestCase {

    func test_it_toggles_launch_at_login_setting() {
        let settingsRepository = SettingsRepositorySpy()
        let permissionsResource = PermissionsResourceDummy()
        let sut = ToggleSettingsUseCaseImpl(settingsRepository: settingsRepository, permissionsResource: permissionsResource)

        sut.toggle(setting: .launchAtLogin)

        try XCTAssertTrue(XCTUnwrap(settingsRepository.toggleLaunchAtLoginCalled))
    }

    func test_it_toggles_paste_directly_setting() {
        let settingsRepository = SettingsRepositorySpy()
        let permissionsResource = PermissionsResourceStub(pastingAllowed: true)
        let sut = ToggleSettingsUseCaseImpl(settingsRepository: settingsRepository, permissionsResource: permissionsResource)

        let result = sut.toggle(setting: .pasteDirectly)

        try XCTAssertTrue(XCTUnwrap(settingsRepository.togglePasteDirectlyCalled))
        XCTAssertNil(result.error())
    }

    func test_toggling_paste_directly_on_fails_when_permissions_are_not_granted() throws {
        let permissionsResource = PermissionsResourceStub(pastingAllowed: false)
        let settingsRepository = SettingsRepositorySpy()
        settingsRepository.lastSettings.pasteDirectly = false
        let sut = ToggleSettingsUseCaseImpl(settingsRepository: settingsRepository, permissionsResource: permissionsResource)

        let result = sut.toggle(setting: .pasteDirectly)

        try XCTAssertEqual(XCTUnwrap(result.error()), ToggleSettingsError.permissionNotGranted)
    }

    func test_toggles_paste_directly_off_even_when_permissions_are_not_granted() {
        let settingsRepository = SettingsRepositorySpy()
        settingsRepository.lastSettings.pasteDirectly = true
        let permissionsResource = PermissionsResourceStub(pastingAllowed: false)
        let sut = ToggleSettingsUseCaseImpl(settingsRepository: settingsRepository, permissionsResource: permissionsResource)

        let result = sut.toggle(setting: .pasteDirectly)

        try XCTAssertTrue(XCTUnwrap(settingsRepository.togglePasteDirectlyCalled))
        XCTAssertNil(result.error())
    }
}
