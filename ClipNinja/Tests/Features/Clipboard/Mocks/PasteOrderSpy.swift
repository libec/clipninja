@testable import ClipNinja
import Combine

class PasteOrderSpy: ClipsRepository, HideAppUseCase, PasteTextUseCase {

    enum PasteSteps {
        case moveAfterPins
        case hideApp
        case paste
    }

    var steps: [PasteSteps] = []

    var clips: AnyPublisher<[Clip], Never> {
        Just(lastClips).eraseToAnyPublisher()
    }

    let lastClips: [Clip]

    init(clips: [Clip]) {
        self.lastClips = clips
    }

    func delete(at index: Int) {

    }

    func togglePin(at index: Int) {

    }

    func moveAfterPins(index: Int) {
        steps.append(.moveAfterPins)
    }

    func hide() {
        steps.append(.hideApp)
    }

    func paste(text: String) {
        steps.append(.paste)
    }
}
