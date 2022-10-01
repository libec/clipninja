import Combine
@testable import ClipNinja
import XCTest

class GetViewPortUseCaseParametrizedTests: XCTestCase {

    let viewPortConfiguration = TestViewPortConfiguration()
    
    func runViewPortPageCalculationTests(
        numberOfClips: Int,
        selectedClip: Int,
        expectedSelectedPage: Int,
        expectedNumberOfPages: Int
    ) {
        let viewPortRepository = InMemoryViewPortRepository()
        viewPortRepository.update(position: selectedClip)
        let clipsRepository = ClipsRepositoryAmountStub(numberOfClips: numberOfClips)
        let sut = GetViewPortUseCaseImpl(
            clipsRepositorty: clipsRepository,
            viewPortRepository: viewPortRepository,
            viewPortConfiguration: viewPortConfiguration
        )
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
        let sut = GetViewPortUseCaseImpl(
            clipsRepositorty: clipsRepository,
            viewPortRepository: viewPortRepository,
            viewPortConfiguration: viewPortConfiguration
        )
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
        let sut = GetViewPortUseCaseImpl(
            clipsRepositorty: clipsRepository,
            viewPortRepository: viewPortRepository,
            viewPortConfiguration: viewPortConfiguration
        )
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
