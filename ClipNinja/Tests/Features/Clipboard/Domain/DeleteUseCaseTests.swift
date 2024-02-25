@testable import ClipNinjaPackage
import XCTest

class DeleteUseCaseTests: XCTestCase {
    func test_it_keeps_view_port_when_deleting() {
        assert(numberOfClipboards: 10, deleteClipboardIndex: 6, expectedIndex: 6)
        assert(numberOfClipboards: 9, deleteClipboardIndex: 0, expectedIndex: 0)
        assert(numberOfClipboards: 4, deleteClipboardIndex: 2, expectedIndex: 2)
        assert(numberOfClipboards: 16, deleteClipboardIndex: 12, expectedIndex: 12)
    }

    func test_it_decrements_view_port_when_deleting_oldest_clip() {
        assert(numberOfClipboards: 2, deleteClipboardIndex: 1, expectedIndex: 0)
        assert(numberOfClipboards: 13, deleteClipboardIndex: 12, expectedIndex: 11)
        assert(numberOfClipboards: 91, deleteClipboardIndex: 90, expectedIndex: 89)
    }

    func test_it_doesnt_decrement_when_deleting_last_clip() {
        assert(numberOfClipboards: 1, deleteClipboardIndex: 0, expectedIndex: 0)
    }

    func assert(numberOfClipboards: Int, deleteClipboardIndex: Int, expectedIndex: Int) {
        let viewPortRepository = InMemoryViewPortRepository()
        viewPortRepository.update(position: deleteClipboardIndex)
        let clipsRepository = ClipsRepositoryStub(lastClips: [Clip](repeating: Clip(text: "", pinned: false), count: numberOfClipboards))
        let sut = DeleteUseCaseImpl(viewPortRepository: viewPortRepository, clipsRepository: clipsRepository)

        sut.delete()

        try XCTAssertEqual(XCTUnwrap(clipsRepository.deletedIndex), deleteClipboardIndex)
        XCTAssertEqual(viewPortRepository.lastPosition, expectedIndex)
    }
}
