final class LocalTutorialResource: TutorialResource {

    var userOnboard = false
    var clipsMovement = 0

    func set(flag: TutorialFlag) {
        switch flag {
        case .onboard:
            userOnboard = true
        }
    }

    func contains(flag: TutorialFlag) -> Bool {
        switch flag {
        case .onboard: return userOnboard
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
