@testable import ClipNinjaPackage
import XCTest

class PasteTextUseCaseTests: XCTestCase {

    func test_it_pastes_directly_when_enabled_in_settings_and_permitted_by_the_system() throws {
        let pasteboardResource = PasteboardResourceSpy()
        let pasteCommand = PasteCommandSpy()
        let sut = PasteTextUseCaseImpl(
            pasteboardResource: pasteboardResource,
            settingsRepository: SettingsRepositoryStub(lastSettings: Settings(pasteDirectly: true, launchAtLogin: false)),
            permissionsResource: PermissionsResourceStub(pastingAllowed: true),
            pasteCommand: pasteCommand
        )

        sut.paste(text: "e_#123d")

        try XCTAssertEqual(XCTUnwrap(pasteboardResource.insertedText), "e_#123d")
        try XCTAssertTrue(XCTUnwrap(pasteCommand.pasteCalled))
    }

    func test_it_skips_paste_command_if_not_permitted_by_the_system() {
        let pasteboardResource = PasteboardResourceSpy()
        let pasteCommand = PasteCommandSpy()
        let sut = PasteTextUseCaseImpl(
            pasteboardResource: pasteboardResource,
            settingsRepository: SettingsRepositoryStub(lastSettings: Settings(pasteDirectly: true, launchAtLogin: false)),
            permissionsResource: PermissionsResourceStub(pastingAllowed: false),
            pasteCommand: pasteCommand
        )

        sut.paste(text: "e_#1aewa23d")

        try XCTAssertEqual(XCTUnwrap(pasteboardResource.insertedText), "e_#1aewa23d")
        XCTAssertNil(pasteCommand.pasteCalled)
    }

    func test_it_skips_paste_command_if_permitted_by_the_system_but_disabled_by_the_user() {
        let pasteboardResource = PasteboardResourceSpy()
        let pasteCommand = PasteCommandSpy()
        let sut = PasteTextUseCaseImpl(
            pasteboardResource: pasteboardResource,
            settingsRepository: SettingsRepositoryStub(lastSettings: Settings(pasteDirectly: false, launchAtLogin: false)),
            permissionsResource: PermissionsResourceStub(pastingAllowed: true),
            pasteCommand: pasteCommand
        )

        sut.paste(text: "e_#1aewa23d")

        try XCTAssertEqual(XCTUnwrap(pasteboardResource.insertedText), "e_#1aewa23d")
        XCTAssertNil(pasteCommand.pasteCalled)
    }
}

class PasteboardResourceSpy: PasteboardResource {

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
