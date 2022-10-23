import Combine
import XCTest
@testable import ClipNinjaPackage

class GetClipsViewPortUseCaseTests: GetClipsViewPortUseCaseParametrizedTests {

    func test_it_shows_view_port_with_calculated_total_and_shown_pages() {
        runViewPortPageCalculationTests(
            numberOfClips: viewPortConfiguration.clipsPerPage - 3,
            selectedClip: 3,
            expectedSelectedPage: 0,
            expectedNumberOfPages: 1
        )

        runViewPortPageCalculationTests(
            numberOfClips: viewPortConfiguration.clipsPerPage * 4 - 2,
            selectedClip: viewPortConfiguration.clipsPerPage * 3 + 5,
            expectedSelectedPage: 3,
            expectedNumberOfPages: 4
        )

        runViewPortPageCalculationTests(
            numberOfClips: viewPortConfiguration.clipsPerPage * 4 + 2,
            selectedClip: viewPortConfiguration.clipsPerPage * 4 + 2,
            expectedSelectedPage: 4,
            expectedNumberOfPages: 5
        )

        runViewPortPageCalculationTests(
            numberOfClips: viewPortConfiguration.clipsPerPage * 4,
            selectedClip: viewPortConfiguration.clipsPerPage * 2 + 2,
            expectedSelectedPage: 2,
            expectedNumberOfPages: 4
        )

        runViewPortPageCalculationTests(
            numberOfClips: viewPortConfiguration.clipsPerPage * 2 + 4,
            selectedClip: viewPortConfiguration.clipsPerPage * 2 + 2,
            expectedSelectedPage: 2,
            expectedNumberOfPages: 3
        )
    }

    func test_it_uses_clip_text_from_repository() {
        let clipTexts = "Nunc quis metus dui sed quis ligula".components(separatedBy: " ")
        let clipsRepository = ClipRepositoryNamesStub(texts: clipTexts)
        let viewPortRepository = InMemoryViewPortRepository()
        viewPortRepository.update(position: 0)
        let sut = GetClipsViewPortUseCaseImpl(
            clipsRepositorty: clipsRepository,
            viewPortRepository: viewPortRepository,
            viewPortConfiguration: viewPortConfiguration
        )

        var subscription = Set<AnyCancellable>()
        let expectation = expectation(description: "")

        sut.clipsViewPort
            .sink { viewPort in
                XCTAssertEqual(clipTexts, viewPort.clips.map(\.text))
                expectation.fulfill()
            }
            .store(in: &subscription)

        waitForExpectations(timeout: .leastNonzeroMagnitude)
    }

    func test_it_uses_pinned_clips_from_repository() {
        let pinnedClips = (0..<viewPortConfiguration.clipsPerPage).map { _ in Bool.random() }
        let clipsRepository = ClipRepositoryPinnedStub(pinnedClips: pinnedClips)
        let viewPortRepository = InMemoryViewPortRepository()
        viewPortRepository.update(position: 0)
        let sut = GetClipsViewPortUseCaseImpl(
            clipsRepositorty: clipsRepository,
            viewPortRepository: viewPortRepository,
            viewPortConfiguration: viewPortConfiguration
        )

        var subscription = Set<AnyCancellable>()
        let expectation = expectation(description: "")

        sut.clipsViewPort
            .sink { viewPort in
                XCTAssertEqual(pinnedClips, viewPort.clips.map(\.pinned))
                expectation.fulfill()
            }
            .store(in: &subscription)

        waitForExpectations(timeout: .leastNonzeroMagnitude)
    }

    func test_it_uses_clips_that_correspond_to_selected_page() {
        runClipsSliceTests(
            clips: Clip.numberStubs(amount: viewPortConfiguration.clipsPerPage - 2),
            selectedClip: 2,
            expectedClips: Clip.numberStubs(range: 0..<(viewPortConfiguration.clipsPerPage - 1))
        )

        runClipsSliceTests(
            clips: Clip.numberStubs(amount: viewPortConfiguration.clipsPerPage * 3),
            selectedClip: viewPortConfiguration.clipsPerPage * 2 + 5,
            expectedClips: Clip.numberStubs(range: viewPortConfiguration.clipsPerPage * 2..<(viewPortConfiguration.clipsPerPage * 3))
        )

        runClipsSliceTests(
            clips: Clip.numberStubs(amount: viewPortConfiguration.clipsPerPage * 4),
            selectedClip: viewPortConfiguration.clipsPerPage * 3,
            expectedClips: Clip.numberStubs(range: viewPortConfiguration.clipsPerPage * 3..<(viewPortConfiguration.clipsPerPage * 4))
        )

        runClipsSliceTests(
            clips: Clip.numberStubs(amount: viewPortConfiguration.clipsPerPage),
            selectedClip: viewPortConfiguration.clipsPerPage - 1,
            expectedClips: Clip.numberStubs(range: 0..<viewPortConfiguration.clipsPerPage)
        )
    }

    func test_it_marks_selected_clip() {
        runSelectedClipTests(
            selectedClip: 3,
            numberOfClips: 8,
            expectedSelectedClip: 3
        )

        runSelectedClipTests(
            selectedClip: viewPortConfiguration.clipsPerPage * 3,
            numberOfClips: viewPortConfiguration.clipsPerPage * 3 + 6,
            expectedSelectedClip: 0
        )

        runSelectedClipTests(
            selectedClip: viewPortConfiguration.clipsPerPage * 3 + 2,
            numberOfClips: viewPortConfiguration.clipsPerPage * 3 + 6,
            expectedSelectedClip: 2
        )
    }
}
