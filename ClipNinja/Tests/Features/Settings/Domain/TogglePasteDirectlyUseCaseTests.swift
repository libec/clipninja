import XCTest
@testable import ClipNinjaPackage

class TogglePasteDirectlyUseCaseTests: XCTestCase {

    func test_it_toggles_paste_directly_setting() {
        let settingsRepository = SettingsRepositorySpy()
        let sut = TogglePasteDirectlyUseCaseImpl(settingsRepository: settingsRepository)

        sut.toggle()

        try XCTAssertTrue(XCTUnwrap(settingsRepository.toggleCalled))
    }
}
