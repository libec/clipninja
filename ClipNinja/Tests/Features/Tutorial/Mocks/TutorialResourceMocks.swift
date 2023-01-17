@testable import ClipNinjaPackage

class TutorialResourceStub: TutorialResource {

    let wentThrough: Bool

    init(wentThrough: Bool) {
        self.wentThrough = wentThrough
    }

    func alreadyWentThroughTutorial() -> Bool {
        return wentThrough
    }
}
