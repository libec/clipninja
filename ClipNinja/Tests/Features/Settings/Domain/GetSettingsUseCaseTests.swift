@testable import ClipNinjaPackage
import Combine
import XCTest

final class GetSettingsUseCaseTests: XCTestCase {
    func test_it_notifies_about_new_settings() {
        let expectedSettings = Settings(pasteDirectly: false, launchAtLogin: false, movePastedClipToTop: true)
        let settingsRepository = SettingsRepositoryStub(lastSettings: expectedSettings)
        let sut = GetSettingsUseCaseImpl(settingsRepository: settingsRepository)
        var subscriptions = Set<AnyCancellable>()

        sut.settings
            .sink { newSettings in
                XCTAssertEqual(newSettings, expectedSettings)
            }
            .store(in: &subscriptions)
    }
}
