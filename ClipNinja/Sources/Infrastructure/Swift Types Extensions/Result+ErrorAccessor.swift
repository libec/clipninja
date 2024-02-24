public extension Result where Failure: Error {
    func error() -> Failure? {
        switch self {
        case .success: nil
        case let .failure(error): error
        }
    }
}
