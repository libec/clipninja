enum TutorialResourceFlag {
    case userOnboard
}

protocol TutorialResource {
    var userOnboard: Bool { get }
    func store(flag: TutorialResourceFlag)
}
