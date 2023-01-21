enum TutorialFlag {
    case onboard
    case pasteText
}

enum TutorialNumericValue {
    case clipsMovement
}

protocol TutorialResource: AnyObject {
    func set(flag: TutorialFlag)
    func contains(flag: TutorialFlag) -> Bool
    func increment(value: TutorialNumericValue)
    func value(for: TutorialNumericValue) -> Int
}
