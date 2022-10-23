@testable import ClipNinjaPackage

class SettingsRepositoryStub: SettingsRepository {
    let shouldPasteDirectly: Bool

    init(shouldPasteDirectly: Bool) {
        self.shouldPasteDirectly = shouldPasteDirectly
    }
}
