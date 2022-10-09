import Combine

protocol ClipsRepository {
    var clips: AnyPublisher<[ClipboardRecord], Never> { get }
    var lastClips: [ClipboardRecord] { get }
    func delete(at index: Int)
}

class InMemoryClipboardsRepository: ClipsRepository {

    static var fakeClips: [ClipboardRecord] {
        let legacyOnboardinTexts = [
            "Yo, Welcome to ClipNinja!",
            "Here you see your clipboard history",
            "You can move using arrow keys",
            "↑ ↑ ↓ ↓ ← → ← →",
            "Text you copy appears here",
            "You can paste with enter",
            "Also, each clipboard is marked with a number",
            "You can paste by pressing that number",
            "Delete with backspace",
            "Pin to top with space",
            "To not paste anything press ESC",
            "Customize shortcut in preferences",
            "That's it. Enjoy!"
        ]
        return legacyOnboardinTexts.map {
            ClipboardRecord(text: $0, pinned: false)
        }
    }

    var clips: AnyPublisher<[ClipboardRecord], Never> {
        currentValueSubject.eraseToAnyPublisher()
    }

    var lastClips: [ClipboardRecord] {
        currentValueSubject.value
    }

    private let currentValueSubject: CurrentValueSubject<[ClipboardRecord], Never> = .init(InMemoryClipboardsRepository.fakeClips)

    func delete(at index: Int) {
        if currentValueSubject.value.indices.contains(index) {
            currentValueSubject.value.remove(at: index)
        }
    }
}
