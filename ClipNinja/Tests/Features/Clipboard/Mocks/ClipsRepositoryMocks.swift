@testable import ClipNinjaPackage
import Combine

typealias ClipsRepositorySpy = ClipsRepositoryStub
class ClipsRepositoryStub: ClipsRepository {
    var lastClips: [Clip]
    var lastPastedClip: Clip?
    var deletedIndex: Int?
    var toggledPin: Int?
    var movedAfterPinsAtIndex: Int?

    var clips: AnyPublisher<[Clip], Never> {
        Just(lastClips)
            .eraseToAnyPublisher()
    }

    init(lastClips: [Clip]) {
        self.lastClips = lastClips
    }

    func delete(at index: Int) {
        lastClips.remove(at: index)
        self.deletedIndex = index
    }

    func togglePin(at index: Int) {
        self.toggledPin = index
    }

    func moveAfterPins(index: Int) {
        self.movedAfterPinsAtIndex = index
    }
}

class ClipsRepositoryAmountStub: ClipsRepositoryStub {

    init(numberOfClips: Int) {
        super.init(lastClips: (0..<numberOfClips).map { index in
            Clip(text: "\(index)", pinned: false)
        })
    }
}

class ClipRepositoryNamesStub: ClipsRepositoryStub {

    init(texts: [String]) {
        super.init(lastClips: texts.map {
            Clip(text: $0, pinned: false)
        })
    }
}

class ClipRepositoryPinnedStub: ClipsRepositoryStub {

    init(pinnedClips: [Bool]) {
        super.init(lastClips: pinnedClips.map {
            Clip(text: "foo", pinned: $0)
        })
    }
}
