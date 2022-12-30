import Foundation

protocol ClipsStorage {
    func persist(clips: [Clip])
    var clips: [Clip] { get }
}

final class ProtectedClipsStorage: ClipsStorage {

    private let clipboardsStorageKey = "Clipboards"

    private let jsonDecoder: JSONDecoder
    private let jsonEncoder: JSONEncoder
    private let fileManager: FileManager

    init(
        jsonDecoder: JSONDecoder,
        jsonEncoder: JSONEncoder,
        fileManager: FileManager
    ) {
        self.jsonDecoder = jsonDecoder
        self.jsonEncoder = jsonEncoder
        self.fileManager = fileManager
    }

    func persist(clips: [Clip]) {
        let url = makeStorage()
        do {
            let data = try jsonEncoder.encode(clips)
            try data.write(to: url, options: [.atomic, .completeFileProtection])
        } catch {
            log(message: "Cant encode clips: \(error)")
        }
    }

    var clips: [Clip] {
        let url = makeStorage()
        do {
            let data = try Data(contentsOf: url, options: [])
            let clips = try jsonDecoder.decode([Clip].self, from: data)
            return clips
        } catch {
            log(message: "Failed to decode clips: \(error)")
            return []
        }
    }

    private func makeStorage() -> URL {
        guard let url = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            log(message: "Failed to make URL to store data")
            fatalError()
        }
        let clipsUrl = url.appending(path: "clips")
        log(message: clipsUrl.path)
        return clipsUrl
    }
}
