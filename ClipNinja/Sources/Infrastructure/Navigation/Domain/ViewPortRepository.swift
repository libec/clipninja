import Combine

protocol ViewPortRepository {
    var position: AnyPublisher<Int, Never> { get }
    func update(position: Int)
    var lastPosition: Int { get }
}

final class InMemoryViewPortRepository: ViewPortRepository {

    private let subject = CurrentValueSubject<Int, Never>(0)

    var position: AnyPublisher<Int, Never> {
        subject.eraseToAnyPublisher()
    }

    var lastPosition: Int {
        subject.value
    }

    func update(position: Int) {
        subject.value = position
    }
}
