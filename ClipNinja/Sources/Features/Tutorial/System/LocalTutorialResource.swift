final class LocalTutorialResource: TutorialResource {
    var userOnboard: Bool = false

    func store(flag: TutorialResourceFlag) {
        switch flag {
        case .userOnboard:
            userOnboard = true
        }
    }
}
