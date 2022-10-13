@testable import ClipNinja
import XCTest

class DeleteUseCaseTests: XCTestCase {

    func test_it_deletes_selected_clip() throws {
        let viewPortRepository = InMemoryViewPortRepository()
        viewPortRepository.update(position: 3)
        let clipsRepository = ClipsRepositoryStub(lastClips: [
            Clip(text: "3_Aefe", pinned: false),
            Clip(text: "3_Aeaaefe", pinned: false),
            Clip(text: "cewasdfe", pinned: false),
            Clip(text: "364sddae", pinned: false),
        ])
        let sut = DeleteUseCaseImpl(viewPortRepository: viewPortRepository, clipsRepository: clipsRepository)

        sut.delete()

        try XCTAssertEqual(XCTUnwrap(clipsRepository.deletedIndex), 3)
    }

    func test_it_decrements_view_port_when_deleting_oldest_clip() {
        let viewPortRepository = InMemoryViewPortRepository()
        viewPortRepository.update(position: 1)
        let clipsRepository = ClipsRepositoryStub(lastClips: [
            Clip(text: "3_Aefe", pinned: false),
            Clip(text: "3_Aeaaefe", pinned: false),
        ])
        let sut = DeleteUseCaseImpl(viewPortRepository: viewPortRepository, clipsRepository: clipsRepository)

        sut.delete()

        try XCTAssertEqual(XCTUnwrap(clipsRepository.deletedIndex), 1)
        XCTAssertEqual(viewPortRepository.lastPosition, 0)
    }

    func test_it_doesnt_decrement_when_deleting_last_clip() {
        let viewPortRepository = InMemoryViewPortRepository()
        viewPortRepository.update(position: 0)
        let clipsRepository = ClipsRepositoryStub(lastClips: [
            Clip(text: "3_Aefe", pinned: false),
        ])
        let sut = DeleteUseCaseImpl(viewPortRepository: viewPortRepository, clipsRepository: clipsRepository)

        sut.delete()

        try XCTAssertEqual(XCTUnwrap(clipsRepository.deletedIndex), 0)
        XCTAssertEqual(viewPortRepository.lastPosition, 0)
    }
}
