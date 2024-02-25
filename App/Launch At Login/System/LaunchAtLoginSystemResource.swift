import ClipNinjaPackage
import ServiceManagement

final class LaunchAtLoginSystemResource: LaunchAtLoginResource {
    private let appService: SMAppService

    init() {
        appService = SMAppService.mainApp
    }

    var enabled: Bool {
        appService.status == .enabled
    }

    func enable() {
        do {
            try appService.register()
        } catch {
            log(message: "Error enabling launch at login feature: \(error.localizedDescription)")
        }
    }

    func disable() {
        do {
            try appService.unregister()
        } catch {
            log(message: "Error disabling launch at login feature: \(error.localizedDescription)")
        }
    }
}
