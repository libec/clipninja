import Combine

protocol ClipsRepository {
    var clips: AnyPublisher<[ClipboardRecord], Never> { get }
    var lastClips: [ClipboardRecord] { get }
    func delete(at index: Int)
    func togglePin(at index: Int)
    func moveAfterPins(index: Int)
}

final class InMemoryClipboardsRepository: ClipsRepository {

    var clips: AnyPublisher<[ClipboardRecord], Never> {
        clipboardRecords.eraseToAnyPublisher()
    }

    var lastClips: [ClipboardRecord] {
        clipboardRecords.value
    }

    private let clipboardRecords: CurrentValueSubject<[ClipboardRecord], Never>

    private let pasteboardObserver: PasteboardObserver
    private let clipsStorage: ClipsStorage
    private var subscriptions = Set<AnyCancellable>()

    init(
        pasteboardObserver: PasteboardObserver,
        clipsStorage: ClipsStorage
    ) {
        self.pasteboardObserver = pasteboardObserver
        self.clipsStorage = clipsStorage
        self.clipboardRecords = .init(clipsStorage.clips)
        observePasteboard()
        setupPersistency()
    }

    func delete(at index: Int) {
        if clipboardRecords.value.indices.contains(index) {
            clipboardRecords.value.remove(at: index)
        }
    }

    func togglePin(at index: Int) {
        if clipboardRecords.value.indices.contains(index) {
            var toggledClip = clipboardRecords.value[index]
            toggledClip.pinned.toggle()
            clipboardRecords.value.remove(at: index)
            let pinned = clipboardRecords.value.filter(\.pinned).count
            clipboardRecords.value.insert(toggledClip, at: max(0, pinned))

        }
    }

    func moveAfterPins(index: Int) {
        if clipboardRecords.value.indices.contains(index) {
            let record = clipboardRecords.value[index]
            clipboardRecords.value.remove(at: index)
            let pinned = clipboardRecords.value.filter(\.pinned).count
            clipboardRecords.value.insert(record, at: max(0, pinned))
        }
    }

    private func setupPersistency() {
        clipboardRecords.sink(receiveValue: { [unowned self] records in
            self.persist(records: records)
        })
        .store(in: &subscriptions)
    }

    private func observePasteboard() {
        pasteboardObserver.newCopiedText.filter { [unowned self] newText in
            return !self.clipboardRecords.value.contains { record in
                record.text == newText
            }
        }.map {
            ClipboardRecord(text: $0, pinned: false)
        }.sink { [unowned self] newRecord in
            // TODO: - Consider moving to use case and handle more safely
            // TODO: - Remove if already exists and is not pinned
            // TODO: - Ignore if already exists and is pinned
            let pinnedRecords = self.clipboardRecords.value.filter({ $0.pinned }).count
            self.clipboardRecords.value.insert(newRecord, at: max(0, pinnedRecords))
        }.store(in: &subscriptions)
    }

    private func persist(records: [ClipboardRecord]) {
        clipsStorage.persist(records: records)
    }
}
