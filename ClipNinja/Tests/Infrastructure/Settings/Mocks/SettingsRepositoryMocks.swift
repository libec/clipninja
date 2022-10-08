@testable import ClipNinja

class SettingsRepositoryStub: SettingsRepository {
    let shouldPasteDirectly: Bool

    init(shouldPasteDirectly: Bool) {
        self.shouldPasteDirectly = shouldPasteDirectly
    }
}
