import Foundation

protocol ClipsResource {
    func persist(clips: [Clip])
    var clips: [Clip] { get }
}

final class ProtectedLocalClipsResource: ClipsResource {

    private let clipboardsStorageKey = "Clipboards"

    private let jsonDecoder: JSONDecoder
    private let jsonEncoder: JSONEncoder
    private let fileManager: FileManager
    private lazy var url = makeClipsURL()

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
        log(message: "Persist clips", category: .storage)
        do {
            let data = try jsonEncoder.encode(clips)
            try data.write(to: url, options: [.atomic, .completeFileProtection])
        } catch {
            log(message: "Cant encode clips: \(error)", category: .storage)
        }
    }

    var clips: [Clip] {
        do {
            let data = try Data(contentsOf: url, options: [])
            let clips = try jsonDecoder.decode([Clip].self, from: data)
            return clips
        } catch {
            log(message: "Failed to decode clips: \(error)", category: .storage)
            return []
        }
    }

    private func makeClipsURL() -> URL {
        guard let url = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            log(message: "Failed to make URL to store data", category: .storage)
            fatalError()
        }
        let clipsUrl = url.appending(path: "clips")
        log(message: "Clips path: \(clipsUrl.path)", category: .storage)
        return clipsUrl
    }
}
