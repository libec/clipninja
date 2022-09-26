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
}

final class ClipboardViewModelImpl: ClipboardViewModel {

    @Published public var shownPage: Int = ViewPortConfiguration.defaultSelectedPage
    @Published public var totalPages: Int = ViewPortConfiguration.totalPages
    @Published public var clipPreviews: [ClipPreview] = []

    private var subscriptions = Set<AnyCancellable>()

    private let clipboards: Clipboards
    private let previewFactory: ClipboardPreviewFactory

    init(
        clipboards: any Clipboards,
        previewFactory: ClipboardPreviewFactory
    ) {
        self.clipboards = clipboards
        self.previewFactory = previewFactory
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
        log(message: "\(event)")
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
            clipboards.paste(at: .index(number))
        }
    }
}
