@testable import ClipNinjaPackage

class PermissionsResourceDummy: PermissionsResource {
    let pastingAllowed: Bool = false
}

class PermissionsResourceStub: PermissionsResource {
    var pastingAllowed: Bool

    init(pastingAllowed: Bool) {
        self.pastingAllowed = pastingAllowed
    }
}
