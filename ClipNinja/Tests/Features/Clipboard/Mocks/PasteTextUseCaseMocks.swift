@testable import ClipNinjaPackage

typealias PasteTextUseCaseDummy = PasteTextUseCaseSpy
class PasteTextUseCaseSpy: PasteTextUseCase {
    var pastedText: String?

    func paste(text: String) {
        pastedText = text
    }
}
