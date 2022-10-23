@testable import ClipNinjaPackage
import XCTest

class PasteTextUseCaseTests: XCTestCase {

    func test_it_pastes_directly_when_enabled_in_settings() throws {
        let pasteboardService = PasteboardServiceSpy()
        let settingsRepository = SettingsRepositoryStub(shouldPasteDirectly: true)
        let pasteCommand = PasteCommandSpy()
        let sut = PasteTextUseCaseImpl(
            pasteboardService: pasteboardService,
            settingsRepository: settingsRepository,
            pasteCommand: pasteCommand
        )

        sut.paste(text: "e_#123d")

        try XCTAssertEqual(XCTUnwrap(pasteboardService.insertedText), "e_#123d")
        try XCTAssertTrue(XCTUnwrap(pasteCommand.pasteCalled))
    }

    func test_it_skips_paste_command_if_not_enabled_in_settings() {
        let pasteboardService = PasteboardServiceSpy()
        let settingsRepository = SettingsRepositoryStub(shouldPasteDirectly: false)
        let pasteCommand = PasteCommandSpy()
        let sut = PasteTextUseCaseImpl(
            pasteboardService: pasteboardService,
            settingsRepository: settingsRepository,
            pasteCommand: pasteCommand
        )

        sut.paste(text: "e_#1aewa23d")

        try XCTAssertEqual(XCTUnwrap(pasteboardService.insertedText), "e_#1aewa23d")
        XCTAssertNil(pasteCommand.pasteCalled)
    }
}

class PasteboardServiceSpy: PasteboardService {

    var insertedText: String?

    func insert(text: String) {
        self.insertedText = text
    }
}

class PasteCommandSpy: PasteCommand {

    var pasteCalled: Bool?

    func paste() {
        pasteCalled = true
    }
}
