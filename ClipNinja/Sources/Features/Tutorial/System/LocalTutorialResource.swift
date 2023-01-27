final class LocalTutorialResource: TutorialResource {

    var userOnboard = false
    var pastedText = false
    var clipsMovement = 0

    func set(flag: TutorialFlag) {
        switch flag {
        case .onboard:
            userOnboard = true
        case .pasteText:
            pastedText = true
        }
    }

    func contains(flag: TutorialFlag) -> Bool {
        switch flag {
        case .onboard: return userOnboard
        case .pasteText: return pastedText
        }
    }

    func increment(value: TutorialNumericValue) {
        switch value {
        case .clipsMovement:
            clipsMovement += 1
        }
    }

    func value(for numericValue: TutorialNumericValue) -> Int {
        switch numericValue {
        case .clipsMovement:
            return clipsMovement
        }
    }
}
