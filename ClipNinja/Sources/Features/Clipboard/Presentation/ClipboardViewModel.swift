import Combine
import Foundation

protocol ClipboardViewModel: ObservableObject {
    var shownPage: Int { get }
    var totalPages: Int { get }
    var clipPreviews: [ClipPreview] { get }
    func onEvent(_ event: ClipboardViewModelEvent)
    func subscribe()
}

enum ClipboardViewModelEvent: Equatable {
    case left
    case right
    case down
    case up
    case enter
    case delete
    case space
    case number(number: Int)
    case escape
}

final class ClipboardViewModelImpl: ClipboardViewModel {

    @Published var shownPage: Int
    @Published var totalPages: Int
    @Published var clipPreviews: [ClipPreview] = []

    private var subscriptions = Set<AnyCancellable>()

    private let clipboards: Clipboards
    private let hideAppUseCase: HideAppUseCase
    private let previewFactory: ClipboardPreviewFactory

    init(
        clipboards: any Clipboards,
        previewFactory: ClipboardPreviewFactory,
        hideAppUseCase: HideAppUseCase,
        viewPortConfiguration: ViewPortConfiguration
    ) {
        self.clipboards = clipboards
        self.previewFactory = previewFactory
        self.hideAppUseCase = hideAppUseCase
        self.shownPage = viewPortConfiguration.defaultSelectedPage
        self.totalPages = viewPortConfiguration.totalPages
    }

    func subscribe() {
        clipboards.clips
            .sink { value in
                self.totalPages = value.numberOfPages
                self.shownPage = value.selectedPage
                self.clipPreviews = value.clips.enumerated().map { index, clip in
                    self.previewFactory.makePreview(from: clip, index: index)
                }
            }.store(in: &subscriptions)
    }

    func onEvent(_ event: ClipboardViewModelEvent) {
        switch event {
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
        case .number(let number):
            // TODO: - Use selectedPage to calculate index
            clipboards.paste(at: .index(number - 1))
        case .escape:
            hideAppUseCase.hide()
        }
    }
}
