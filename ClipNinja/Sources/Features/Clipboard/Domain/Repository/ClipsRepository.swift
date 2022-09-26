import Combine

protocol ClipsRepository {
    var clips: AnyPublisher<[ClipboardRecord], Never> { get }
    var lastClips: [ClipboardRecord] { get }
}
