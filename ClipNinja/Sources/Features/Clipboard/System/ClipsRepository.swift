import Combine

protocol ClipsRepository {
    var clips: AnyPublisher<[Clip], Never> { get }
    var lastClips: [Clip] { get }
    func delete(at index: Int)
    func togglePin(at index: Int)
    func moveAfterPins(index: Int)
}

final class InMemoryClipboardsRepository: ClipsRepository {

    var clips: AnyPublisher<[Clip], Never> {
        clipsSubject.eraseToAnyPublisher()
    }

    var lastClips: [Clip] {
        clipsSubject.value
    }

    private let clipsSubject: CurrentValueSubject<[Clip], Never>

    private let pasteboardObserver: PasteboardObserver
    private let clipsStorage: ClipsStorage
    private var subscriptions = Set<AnyCancellable>()

    init(
        pasteboardObserver: PasteboardObserver,
        clipsStorage: ClipsStorage
    ) {
        self.pasteboardObserver = pasteboardObserver
        self.clipsStorage = clipsStorage
        self.clipsSubject = .init(clipsStorage.clips)
        observePasteboard()
        setupPersistency()
    }

    func delete(at index: Int) {
        if clipsSubject.value.indices.contains(index) {
            clipsSubject.value.remove(at: index)
        }
    }

    func togglePin(at index: Int) {
        if clipsSubject.value.indices.contains(index) {
            var toggledClip = clipsSubject.value[index]
            toggledClip.pinned.toggle()
            clipsSubject.value.remove(at: index)
            let pinned = clipsSubject.value.filter(\.pinned).count
            clipsSubject.value.insert(toggledClip, at: max(0, pinned))

        }
    }

    func moveAfterPins(index: Int) {
        if clipsSubject.value.indices.contains(index) {
            let clip = clipsSubject.value[index]
            clipsSubject.value.remove(at: index)
            let pinned = clipsSubject.value.filter(\.pinned).count
            clipsSubject.value.insert(clip, at: max(0, pinned))
        }
    }

    private func setupPersistency() {
        clipsSubject.sink(receiveValue: { [unowned self] clips in
            self.persist(clips: clips)
        })
        .store(in: &subscriptions)
    }

    private func observePasteboard() {
        pasteboardObserver.newCopiedText.filter { [unowned self] newText in
            return !self.clipsSubject.value.contains { clip in
                clip.text == newText
            }
        }.map {
            Clip(text: $0, pinned: false)
        }.sink { [unowned self] newClip in
            // TODO: - Remove if already exists and is not pinned
            // TODO: - Ignore if already exists and is pinned
            let pinnedClips = self.clipsSubject.value.filter({ $0.pinned }).count
            self.clipsSubject.value.insert(newClip, at: max(0, pinnedClips))
        }.store(in: &subscriptions)
    }

    private func persist(clips: [Clip]) {
        clipsStorage.persist(clips: clips)
    }
}
