@testable import ClipNinjaPackage
import Combine

class PasteOrderSpy: ClipsRepository, HideAppUseCase, PasteTextUseCase {
    enum PasteSteps {
        case moveAfterPins
        case hideApp
        case paste
        case setLastClip
    }

    var steps: [PasteSteps] = []

    var clips: AnyPublisher<[Clip], Never> {
        Just(lastClips).eraseToAnyPublisher()
    }

    var lastPastedClip: Clip? = nil {
        didSet {
            steps.append(.setLastClip)
        }
    }

    let lastClips: [Clip]

    init(clips: [Clip]) {
        lastClips = clips
    }

    func delete(at _: Int) {}

    func togglePin(at _: Int) {}

    func moveAfterPins(index _: Int) {
        steps.append(.moveAfterPins)
    }

    func hide() {
        steps.append(.hideApp)
    }

    func paste(text _: String) {
        steps.append(.paste)
    }
}
