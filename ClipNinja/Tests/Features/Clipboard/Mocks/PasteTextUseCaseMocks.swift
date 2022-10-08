@testable import ClipNinja

typealias PasteTextUseCaseDummy = PasteTextUseCaseSpy
class PasteTextUseCaseSpy: PasteTextUseCase {

    var pastedText: String?

    func paste(text: String) {
        self.pastedText = text
    }
}
