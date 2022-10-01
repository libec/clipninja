import Combine
import XCTest
@testable import ClipNinja

class GetViewPortUseCaseTests: XCTestCase {

    func test_it_shows_view_port_with_selected_clip_and_calculated_pages() {
        runViewPortCalculationTests(
            numberOfClips: ViewPortConfiguration.clipsPerPage - 3,
            selectedClip: 3,
            expectedSelectedPage: 0,
            expectedNumberOfPages: 1
        )

        runViewPortCalculationTests(
            numberOfClips: ViewPortConfiguration.clipsPerPage * 4 - 2,
            selectedClip: ViewPortConfiguration.clipsPerPage * 3 + 5,
            expectedSelectedPage: 3,
            expectedNumberOfPages: 4
        )

        runViewPortCalculationTests(
            numberOfClips: ViewPortConfiguration.clipsPerPage * 4 + 2,
            selectedClip: ViewPortConfiguration.clipsPerPage * 4 + 2,
            expectedSelectedPage: 4,
            expectedNumberOfPages: 5
        )

        runViewPortCalculationTests(
            numberOfClips: ViewPortConfiguration.clipsPerPage * 4,
            selectedClip: ViewPortConfiguration.clipsPerPage * 2 + 2,
            expectedSelectedPage: 2,
            expectedNumberOfPages: 4
        )

        runViewPortCalculationTests(
            numberOfClips: ViewPortConfiguration.clipsPerPage * 2 + 4,
            selectedClip: ViewPortConfiguration.clipsPerPage * 2 + 2,
            expectedSelectedPage: 2,
            expectedNumberOfPages: 3
        )
    }

    func test_it_uses_clip_text_from_repository() {
        let clipTexts = "Nunc quis metus dui sed quis ligula".components(separatedBy: " ")
        let clipsRepository = ClipRepositoryNamesStub(texts: clipTexts)
        let viewPortRepository = InMemoryViewPortRepository()
        viewPortRepository.update(position: 0)
        let sut = GetViewPortUseCaseImpl(
            clipsRepositorty: clipsRepository,
            viewPortRepository: viewPortRepository
        )

        var subscription = Set<AnyCancellable>()
        let expectation = expectation(description: "")

        sut.clips
            .sink { viewPort in
                XCTAssertEqual(clipTexts, viewPort.clips.map(\.text))
                expectation.fulfill()
            }
            .store(in: &subscription)

        waitForExpectations(timeout: .leastNonzeroMagnitude)
    }

    func test_it_uses_pinned_clips_from_repository() {
        let pinnedClips = (0..<ViewPortConfiguration.clipsPerPage).map { _ in Bool.random() }
        let clipsRepository = ClipRepositoryPinnedStub(pinnedClips: pinnedClips)
        let viewPortRepository = InMemoryViewPortRepository()
        viewPortRepository.update(position: 0)
        let sut = GetViewPortUseCaseImpl(
            clipsRepositorty: clipsRepository,
            viewPortRepository: viewPortRepository
        )

        var subscription = Set<AnyCancellable>()
        let expectation = expectation(description: "")

        sut.clips
            .sink { viewPort in
                XCTAssertEqual(pinnedClips, viewPort.clips.map(\.pinned))
                expectation.fulfill()
            }
            .store(in: &subscription)

        waitForExpectations(timeout: .leastNonzeroMagnitude)
    }

    func test_it_uses_clips_that_correspond_to_selected_page() {
        runClipsSliceTests(
            clipboardRecords: ClipboardRecord.numberStubs(amount: ViewPortConfiguration.clipsPerPage - 2),
            selectedClip: 2,
            expectedClips: Clip.numberStubs(range: 0..<(ViewPortConfiguration.clipsPerPage - 2), selected: 2)
        )

        runClipsSliceTests(
            clipboardRecords: ClipboardRecord.numberStubs(amount: ViewPortConfiguration.clipsPerPage * 3),
            selectedClip: ViewPortConfiguration.clipsPerPage * 2 + 5,
            expectedClips: Clip.numberStubs(range: ViewPortConfiguration.clipsPerPage * 2..<(ViewPortConfiguration.clipsPerPage * 3), selected: 5)
        )

        runClipsSliceTests(
            clipboardRecords: ClipboardRecord.numberStubs(amount: ViewPortConfiguration.clipsPerPage * 4),
            selectedClip: ViewPortConfiguration.clipsPerPage * 3,
            expectedClips: Clip.numberStubs(range: ViewPortConfiguration.clipsPerPage * 3..<(ViewPortConfiguration.clipsPerPage * 4), selected: 0)
        )
    }

    func test_it_marks_selected_clip() {
        runSelectedClipTests(
            selectedClip: 3,
            numberOfClips: 8,
            expectedSelectedClip: 3
        )

        runSelectedClipTests(
            selectedClip: ViewPortConfiguration.clipsPerPage * 3,
            numberOfClips: ViewPortConfiguration.clipsPerPage * 3 + 6,
            expectedSelectedClip: 0
        )

        runSelectedClipTests(
            selectedClip: ViewPortConfiguration.clipsPerPage * 3 + 2,
            numberOfClips: ViewPortConfiguration.clipsPerPage * 3 + 6,
            expectedSelectedClip: 2
        )
    }

    func runViewPortCalculationTests(
        numberOfClips: Int,
        selectedClip: Int,
        expectedSelectedPage: Int,
        expectedNumberOfPages: Int
    ) {
        let viewPortRepository = InMemoryViewPortRepository()
        viewPortRepository.update(position: selectedClip)
        let clipsRepository = ClipsRepositoryAmountStub(numberOfClips: numberOfClips)
        let sut = GetViewPortUseCaseImpl(clipsRepositorty: clipsRepository, viewPortRepository: viewPortRepository)
        var subscription = Set<AnyCancellable>()
        let expectation = expectation(description: "")

        sut.clips
            .sink { viewPort in
                XCTAssertEqual(expectedNumberOfPages, viewPort.numberOfPages)
                XCTAssertEqual(expectedSelectedPage, viewPort.selectedPage)
                expectation.fulfill()
            }
            .store(in: &subscription)

        waitForExpectations(timeout: .leastNonzeroMagnitude)
    }

    func runSelectedClipTests(
        selectedClip: Int,
        numberOfClips: Int,
        expectedSelectedClip: Int
    ) {
        let viewPortRepository = InMemoryViewPortRepository()
        viewPortRepository.update(position: selectedClip)
        let clipsRepository = ClipsRepositoryAmountStub(numberOfClips: numberOfClips)
        let sut = GetViewPortUseCaseImpl(clipsRepositorty: clipsRepository, viewPortRepository: viewPortRepository)
        var subscription = Set<AnyCancellable>()
        let expectation = expectation(description: "")

        sut.clips
            .sink { viewPort in
                XCTAssertTrue(viewPort.clips[expectedSelectedClip].selected)
                viewPort.clips.enumerated().forEach { index, clip in
                    XCTAssertEqual(clip.selected, index == expectedSelectedClip)
                }
                expectation.fulfill()
            }
            .store(in: &subscription)

        waitForExpectations(timeout: .leastNonzeroMagnitude)
    }

    func runClipsSliceTests(
        clipboardRecords: [ClipboardRecord],
        selectedClip: Int,
        expectedClips: [Clip]
    ) { 
        let viewPortRepository = InMemoryViewPortRepository()
        viewPortRepository.update(position: selectedClip)
        let clipsRepository = ClipsRepositoryStub(lastClips: clipboardRecords)
        let sut = GetViewPortUseCaseImpl(clipsRepositorty: clipsRepository, viewPortRepository: viewPortRepository)
        var subscription = Set<AnyCancellable>()
        let expectation = expectation(description: "")

        sut.clips
            .sink { viewPort in
                XCTAssertEqual(expectedClips, viewPort.clips)
                expectation.fulfill()
            }
            .store(in: &subscription)

        waitForExpectations(timeout: .leastNonzeroMagnitude)
    }
}
