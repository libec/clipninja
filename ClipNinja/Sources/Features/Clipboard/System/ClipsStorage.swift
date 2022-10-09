import Foundation

protocol ClipsStorage {
    func persist(records: [ClipboardRecord])
    var clips: [ClipboardRecord] { get }
}

final class UserDefaultsClipsStorage: ClipsStorage {

    private let clipboardsStorageKey = "Clipboards"

    private let jsonDecoder: JSONDecoder
    private let jsonEncoder: JSONEncoder
    private let userDefaults: UserDefaults

    init(
        jsonDecoder: JSONDecoder,
        jsonEncoder: JSONEncoder,
        userDefaults: UserDefaults
    ) {
        self.jsonDecoder = jsonDecoder
        self.jsonEncoder = jsonEncoder
        self.userDefaults = userDefaults
    }

    func persist(records: [ClipboardRecord]) {
        do {
            let data = try jsonEncoder.encode(records)
            userDefaults.set(data, forKey: clipboardsStorageKey)
        } catch {
            log(message: "Cant encode clips: \(error)")
        }
    }

    var clips: [ClipboardRecord] {
        guard let data = userDefaults.data(forKey: clipboardsStorageKey) else {
            log(message: "No data in user defaults")
            return []
        }
        do {
            let clips = try jsonDecoder.decode([ClipboardRecord].self, from: data)
            return clips
        } catch {
            log(message: "Failed to decode clips: \(error)")
            return []
        }
    }
}
