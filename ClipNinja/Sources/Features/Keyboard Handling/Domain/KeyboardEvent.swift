public enum KeyboardEvent: Equatable {
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
