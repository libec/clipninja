@testable import ClipNinja
import Combine

class ClipsRepositoryStub: ClipsRepository {
    let lastClips: [ClipboardRecord]

    var clips: AnyPublisher<[ClipboardRecord], Never> {
        Just(lastClips)
            .eraseToAnyPublisher()
    }

    init(lastClips: [ClipboardRecord]) {
        self.lastClips = lastClips
    }
}

class ClipsRepositoryAmountStub: ClipsRepositoryStub {

    init(numberOfClips: Int) {
        super.init(lastClips: (0..<numberOfClips).map { index in
            ClipboardRecord(text: "\(index)", pinned: false)
        })
    }
}

class ClipRepositoryNamesStub: ClipsRepositoryStub {

    init(texts: [String]) {
        super.init(lastClips: texts.map {
            ClipboardRecord(text: $0, pinned: false)
        })
    }
}

class ClipRepositoryPinnedStub: ClipsRepositoryStub {

    init(pinnedClips: [Bool]) {
        super.init(lastClips: pinnedClips.map {
            ClipboardRecord(text: "foo", pinned: $0)
        })
    }
}
