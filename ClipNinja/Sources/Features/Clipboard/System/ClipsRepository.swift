import Combine
import Foundation

protocol ClipsRepository: AnyObject {
    var clips: AnyPublisher<[Clip], Never> { get }
    var lastClips: [Clip] { get }
    var lastPastedClip: Clip? { get set }
    func delete(at index: Int)
    func togglePin(at index: Int)
    func moveAfterPins(index: Int)
}

final class ClipsRepositoryImpl<StorageScheduler: Scheduler>: ClipsRepository {
    var clips: AnyPublisher<[Clip], Never> {
        clipsSubject.eraseToAnyPublisher()
    }

    var lastClips: [Clip] {
        clipsSubject.value
    }

    var lastPastedClip: Clip?

    private let clipsSubject: CurrentValueSubject<[Clip], Never>

    private let pasteboardObserver: PasteboardObserver
    private let clipsResource: ClipsResource
    private let viewPortConfiguration: ViewPortConfiguration
    private let storageScheduler: StorageScheduler
    private let settingsRepository: SettingsRepository
    private var subscriptions = Set<AnyCancellable>()

    init(
        pasteboardObserver: PasteboardObserver,
        clipsResource: ClipsResource,
        viewPortConfiguration: ViewPortConfiguration,
        storageScheduler: StorageScheduler,
        settingsRepository: SettingsRepository
    ) {
        self.pasteboardObserver = pasteboardObserver
        self.clipsResource = clipsResource
        self.viewPortConfiguration = viewPortConfiguration
        self.storageScheduler = storageScheduler
        self.settingsRepository = settingsRepository
        clipsSubject = .init(clipsResource.clips)
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
        clipsSubject
            .throttle(for: 1, scheduler: storageScheduler, latest: true)
            .sink(receiveValue: { [unowned self] clips in
                persist(clips: clips)
            })
            .store(in: &subscriptions)
    }

    private func observePasteboard() {
        pasteboardObserver.newCopiedText.map(Clip.newClip(with:))
            .sink { [unowned self] newClip in
                addNewClipFromPasteboard(newClip: newClip)
            }.store(in: &subscriptions)
    }

    private func addNewClipFromPasteboard(newClip: Clip) {
        let isNewClipAlreadyPinned = clipsSubject.value.contains { clip in
            clip.text == newClip.text && clip.pinned
        }
        if isNewClipAlreadyPinned {
            return
        }

        let newClipIsTheSameAsLastlyPastedClip = lastPastedClip?.text == newClip.text
        let shouldSkipMovingExistingClipsToTheMostRecent = !settingsRepository.lastSettings.movePastedClipToTop

        if newClipIsTheSameAsLastlyPastedClip, shouldSkipMovingExistingClipsToTheMostRecent {
            return
        }

        if let clipIndex = clipsSubject.value.firstIndex(of: newClip) {
            delete(at: clipIndex)
        }
        let pinnedClips = clipsSubject.value.filter(\.pinned).count
        clipsSubject.value.insert(newClip, at: max(0, pinnedClips))
        clipsSubject.value = Array(clipsSubject.value.prefix(viewPortConfiguration.clipsPerPage * viewPortConfiguration.totalPages))
    }

    private func persist(clips: [Clip]) {
        clipsResource.persist(clips: clips)
    }
}
