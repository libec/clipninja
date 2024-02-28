import ClipNinjaPackage
import Combine
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    private let windowsController: WindowsController
    private let menuBarController: MenuBarController
    private let migrationController: MigrationController

    override init() {
        let instanceProvider: InstanceProvider = ApplicationAssembly(systemAssemblies: [
            KeyboardHandlingAssembly(),
            LaunchAtLoginAssembly(),
            MigrationAssembly(),
            WindowsAssembly(),
        ]).resolveDependencyGraph()
        windowsController = instanceProvider.resolve(WindowsController.self)
        menuBarController = instanceProvider.resolve(MenuBarController.self)
        migrationController = instanceProvider.resolve(MigrationController.self)
        super.init()
    }

    func applicationDidFinishLaunching(_: Notification) {
        migrationController.migrate()
        menuBarController.setupMenuBar()
        windowsController.startNavigation()
        windowsController.openFirstWindow()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool { false }

    func applicationWillResignActive(_: Notification) {
        windowsController.resignActive()
    }

    static func main() {
        log(message: "Main invoked")
        defer {
            log(message: "Main finished")
        }
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate
        app.run()
    }
}
