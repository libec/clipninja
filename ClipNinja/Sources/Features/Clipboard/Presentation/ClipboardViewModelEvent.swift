enum ClipboardViewModelEvent: Equatable {

    case lifecycle(LifecycleEvent)
    case keyboard(KeyboardEvent)

    enum LifecycleEvent: Equatable {
        case appear
    }
    enum KeyboardEvent: Equatable {
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
}
