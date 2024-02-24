import Combine

protocol ClipboardViewModel: ObservableObject {
    var shownPage: Int { get }
    var totalPages: Int { get }
    var clipPreviews: [ClipPreview] { get }
    func onEvent(_ event: ClipboardViewModelEvent)
}

final class ClipboardViewModelImpl: ClipboardViewModel {
    @Published var shownPage: Int
    @Published var totalPages: Int
    @Published var clipPreviews: [ClipPreview] = []

    private var subscriptions = Set<AnyCancellable>()

    private let clipboards: Clipboards
    private let hideAppUseCase: HideAppUseCase
    private let previewFactory: ClipboardPreviewFactory
    private let checkTutorialUseCase: CheckTutorialUseCase

    init(
        clipboards: any Clipboards,
        previewFactory: ClipboardPreviewFactory,
        hideAppUseCase: HideAppUseCase,
        viewPortConfiguration: ViewPortConfiguration,
        checkTutorialUseCase: CheckTutorialUseCase
    ) {
        self.clipboards = clipboards
        self.previewFactory = previewFactory
        self.hideAppUseCase = hideAppUseCase
        self.checkTutorialUseCase = checkTutorialUseCase
        shownPage = viewPortConfiguration.defaultSelectedPage
        totalPages = viewPortConfiguration.totalPages
    }

    func onEvent(_ event: ClipboardViewModelEvent) {
        switch event {
        case let .keyboard(keyboardEvent):
            switch keyboardEvent {
            case .left:
                clipboards.move(to: .left)
            case .right:
                clipboards.move(to: .right)
            case .down:
                clipboards.move(to: .down)
            case .up:
                clipboards.move(to: .up)
            case .enter:
                clipboards.paste(at: .selected)
            case .delete:
                clipboards.delete()
            case .space:
                clipboards.pin()
            case let .number(number):
                clipboards.paste(at: .index(number - 1))
            case .escape:
                hideAppUseCase.hide()
            }
        case let .lifecycle(lifecycleEvent):
            switch lifecycleEvent {
            case .appear:
                subscribe()
                checkTutorialUseCase.checkTutorials(for: .clipsAppear)
            }
        }
    }

    private func subscribe() {
        clipboards.clipsViewPort
            .sink { [weak self] value in
                self?.totalPages = value.numberOfPages
                self?.shownPage = value.selectedPage
                self?.clipPreviews = value.clips.enumerated().compactMap { index, clip in
                    self?.previewFactory.makePreview(from: clip, index: index, selected: index == value.selectedClipIndex)
                }
            }.store(in: &subscriptions)
    }
}
