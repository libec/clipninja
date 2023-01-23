import ApplicationServices

final class SystemPermissionsResource: PermissionsResource {

    init() { }

    var pastingAllowed: Bool {
        AXIsProcessTrusted()
    }
}
