import Foundation

protocol ClipsStorage {
    func persist(clips: [Clip])
    var clips: [Clip] { get }
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

    func persist(clips: [Clip]) {
        do {
            let data = try jsonEncoder.encode(clips)
            userDefaults.set(data, forKey: clipboardsStorageKey)
        } catch {
            log(message: "Cant encode clips: \(error)")
        }
    }

    var clips: [Clip] {
        guard let data = userDefaults.data(forKey: clipboardsStorageKey) else {
            log(message: "No data in user defaults")
            return []
        }
        do {
            let clips = try jsonDecoder.decode([Clip].self, from: data)
            return clips
        } catch {
            log(message: "Failed to decode clips: \(error)")
            return []
        }
    }
}
