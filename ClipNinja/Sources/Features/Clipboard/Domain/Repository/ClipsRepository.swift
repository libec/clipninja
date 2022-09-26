import Combine

protocol ClipsRepository {
    var clips: AnyPublisher<[Clip], Never> { get }
    var lastClips: [Clip] { get }
}
