enum ClipboardViewModelEvent: Equatable {

    case lifecycle(LifecycleEvent)
    case keyboard(KeyboardEvent)

    enum LifecycleEvent: Equatable {
        case appear
    }
}
