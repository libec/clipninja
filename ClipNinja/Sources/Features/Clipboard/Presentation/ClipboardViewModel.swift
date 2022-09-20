import Foundation

public struct Clip {
    let text: String
    let pinned: Bool
    let selected: Bool
}

public protocol ClipboardViewModel: ObservableObject {
    var shownTab: Int { get }
    var totalTabs: Int { get }
    var clips: [Clip] { get }
    func onEvent(input: ClipboardViewModelInput)
}

public enum ClipboardViewModelInput {
    case onLeft
    case onRight
    case onDown
    case onUp
    case onEnter
    case onDelete
    case onNumber(number: Int)
}
