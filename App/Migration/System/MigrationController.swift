import ClipNinjaPackage
import Foundation

final class MigrationController {
    private let legacyKey = "Clipboards"

    func migrate() {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: legacyKey) != nil {
            log(message: "Removing legacy defaults", category: .migration)
            defaults.removeObject(forKey: legacyKey)
        }
    }
}
