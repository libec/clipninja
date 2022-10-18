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
        moveToTop(index: index, togglePin: true)
    }

    func moveAfterPins(index: Int) {
        moveToTop(index: index, togglePin: false)
    }

    private func moveToTop(index: Int, togglePin: Bool) {
        if clipsSubject.value.indices.contains(index) {
            var clip = clipsSubject.value[index]
            clipsSubject.value.remove(at: index)
            let pinned = clipsSubject.value.filter(\.pinned).count
            if togglePin {
                clip.pinned.toggle()
            }
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
        pasteboardObserver.newCopiedText.map(Clip.newClip(with:))
            .sink { [unowned self] newClip in
                self.addNewClipFromPasteboard(newClip: newClip)
            }.store(in: &subscriptions)
    }

    private func addNewClipFromPasteboard(newClip: Clip) {
        let isNewClipAlreadyPinned = clipsSubject.value.contains { clip in
            clip.text == newClip.text && clip.pinned
        }
        if !isNewClipAlreadyPinned {
            if let clipIndex = clipsSubject.value.firstIndex(of: newClip) {
                delete(at: clipIndex)
            }
            let pinnedClips = self.clipsSubject.value.filter({ $0.pinned }).count
            self.clipsSubject.value.insert(newClip, at: max(0, pinnedClips))
        }
    }

    private func persist(clips: [Clip]) {
        clipsStorage.persist(clips: clips)
    }
}
