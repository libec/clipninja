import SwiftUI
import Combine
import ClipNinjaPackage

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    private let windowsController: WindowsController
    private let menuBarController: MenuBarController

    override init() {
        let instanceProvider: InstanceProvider = ApplicationAssembly(systemAssemblies: [
            KeyboardHandlingAssembly(),
            LaunchAtLoginAssembly(),
            WindowsAssembly()
        ]).resolveDependencyGraph()
        self.windowsController = instanceProvider.resolve(WindowsController.self)
        self.menuBarController = instanceProvider.resolve(MenuBarController.self)
        super.init()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        menuBarController.setupMenuBar()
        windowsController.startNavigation()
        windowsController.openFirstWindow()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { false }

    func applicationWillResignActive(_ notification: Notification) {
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
