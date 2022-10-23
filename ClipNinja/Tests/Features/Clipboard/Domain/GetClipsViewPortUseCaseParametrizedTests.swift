import Combine
@testable import ClipNinjaPackage
import XCTest

class GetClipsViewPortUseCaseParametrizedTests: XCTestCase {

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
        let sut = GetClipsViewPortUseCaseImpl(
            clipsRepositorty: clipsRepository,
            viewPortRepository: viewPortRepository,
            viewPortConfiguration: viewPortConfiguration
        )
        var subscription = Set<AnyCancellable>()
        let expectation = expectation(description: "")

        sut.clipsViewPort
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
        let sut = GetClipsViewPortUseCaseImpl(
            clipsRepositorty: clipsRepository,
            viewPortRepository: viewPortRepository,
            viewPortConfiguration: viewPortConfiguration
        )
        var subscription = Set<AnyCancellable>()
        let expectation = expectation(description: "")

        sut.clipsViewPort
            .sink { viewPort in
                XCTAssertEqual(viewPort.selectedClipIndex, expectedSelectedClip)
                expectation.fulfill()
            }
            .store(in: &subscription)

        waitForExpectations(timeout: .leastNonzeroMagnitude)
    }

    func runClipsSliceTests(
        clips: [Clip],
        selectedClip: Int,
        expectedClips: [Clip]
    ) {
        let viewPortRepository = InMemoryViewPortRepository()
        viewPortRepository.update(position: selectedClip)
        let clipsRepository = ClipsRepositoryStub(lastClips: clips)
        let sut = GetClipsViewPortUseCaseImpl(
            clipsRepositorty: clipsRepository,
            viewPortRepository: viewPortRepository,
            viewPortConfiguration: viewPortConfiguration
        )
        var subscription = Set<AnyCancellable>()
        let expectation = expectation(description: "")

        sut.clipsViewPort
            .sink { viewPort in
                XCTAssertEqual(expectedClips, viewPort.clips)
                expectation.fulfill()
            }
            .store(in: &subscription)

        waitForExpectations(timeout: .leastNonzeroMagnitude)
    }
}
