import Combine

protocol ViewPortRepository {
    var position: AnyPublisher<Int, Never> { get }
    func update(position: Int)
    var lastPosition: Int { get }
}
