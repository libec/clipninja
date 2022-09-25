import Foundation

public protocol ClipboardViewModel: ObservableObject {
    var shownTab: Int { get }
    var totalTabs: Int { get }
    var clipPreviews: [ClipPreview] { get }
    func onEvent(input: ClipboardViewModelInput)
}

public enum ClipboardViewModelInput {
    case onLeft
    case onRight
    case onDown
    case onUp
    case onEnter
    case onDelete
    case onSpace
    case onNumber(number: Int)
}

public final class ClipboardViewModelImpl: ClipboardViewModel {

    @Published public var shownTab: Int = 0
    @Published public var totalTabs: Int = 9
    @Published public var clipPreviews: [ClipPreview] = []

    private let clipboards: Clipboards
    private let previewFactory: ClipboardPreviewFactory


    init(
        clipboards: any Clipboards,
        previewFactory: ClipboardPreviewFactory
    ) {
        self.clipboards = clipboards
        self.previewFactory = previewFactory
    }

    public func onEvent(input: ClipboardViewModelInput) {
        log(message: "\(input)")
        switch input {
        case .onLeft:
            break
        case .onRight:
            break
        case .onDown:
            break
        case .onUp:
            break
        case .onEnter:
            break
        case .onDelete:
            break
        case .onSpace:
            break
        case .onNumber(let number):
            break
        }
    }
}
