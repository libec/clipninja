import XCTest
@testable import ClipNinjaPackage

class ToggleLaunchAtLoginUseCaseTests: XCTestCase {

    func test_it_toggles_launch_at_login_setting() {
        let settingsRepository = SettingsRepositorySpy()
        let sut = ToggleLaunchAtLoginUseCaseImpl(settingsRepository: settingsRepository)

        sut.toggle()

        try XCTAssertTrue(XCTUnwrap(settingsRepository.toggleLaunchAtLoginCalled))
    }
}
