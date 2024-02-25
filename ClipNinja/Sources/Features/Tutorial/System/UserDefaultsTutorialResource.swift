import Foundation

class UserDefaultsTutorialResource: TutorialResource {
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    func set(flag: TutorialFlag) {
        userDefaults.setValue(true, forKey: flag.defaultsKey)
    }

    func contains(flag: TutorialFlag) -> Bool {
        userDefaults.bool(forKey: flag.defaultsKey)
    }

    func increment(value: TutorialNumericValue) {
        let storedValue = userDefaults.integer(forKey: value.defaultsKey)
        userDefaults.set(storedValue + 1, forKey: value.defaultsKey)
    }

    func value(for value: TutorialNumericValue) -> Int {
        userDefaults.integer(forKey: value.defaultsKey)
    }
}

private extension TutorialNumericValue {
    private var key: String {
        switch self {
        case .clipsMovement: "ClipsMovement"
        }
    }

    var defaultsKey: String {
        "Tutorials.\(key)"
    }
}

private extension TutorialFlag {
    private var key: String {
        switch self {
        case .pasteText: "PasteText"
        case .onboard: "Onboard"
        }
    }

    var defaultsKey: String {
        "Tutorials.\(key)"
    }
}
