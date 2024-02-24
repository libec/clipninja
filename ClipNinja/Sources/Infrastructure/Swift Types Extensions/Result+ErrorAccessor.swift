public extension Result where Failure: Error {
    func error() -> Failure? {
        switch self {
        case .success: return nil
        case let .failure(error): return error
        }
    }
}
