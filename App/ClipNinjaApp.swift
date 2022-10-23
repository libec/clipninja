import SwiftUI
import Combine
import ClipNinjaPackage

class AppDelegate: NSObject, NSApplicationDelegate {

    private var window: NSWindow!

    private let applicationAssembly: ApplicationAssembly
    private let instanceProvider: InstanceProvider
    private var statusItem: NSStatusItem?
    private let keyboardController: KeyboardController

    override init() {
        self.keyboardController = KeyboardController()
        let keyboardHandlingAssembly = KeyboardHandlingAssembly(keyboardNotifier: keyboardController)
        self.applicationAssembly = ApplicationAssembly(systemAssemblies: [keyboardHandlingAssembly])
        self.instanceProvider = applicationAssembly.resolveDependencyGraph()
        super.init()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        window = ClipboardWindow(
            keyboardController: keyboardController,
            contentRect: NSRect(x: 0, y: 0, width: 650, height: 600),
            styleMask: [.titled],
            backing: .buffered,
            defer: true
        )
        setupSettings()
        instanceProvider.resolve(Navigation.self).subscribe()
        window.contentView = NSHostingView(rootView: clipsView)
        window.makeKeyAndOrderFront(nil)
        window.center()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }

    var clipsView: some View {
        instanceProvider.resolve(AnyView.self, name: AssemblyKeys.clipboardView.rawValue)
            .onAppear {
                NSApp.activate(ignoringOtherApps: true)
            }
    }

    private func setupSettings() {
        guard statusItem == nil else { return }

        let settingsView = instanceProvider.resolve(SettingsView.self)
        let view = NSHostingView(rootView: settingsView)

        view.frame = NSRect(x: 0, y: 0, width: 400, height: 200)

        // TODO: - Replace with MenuBarExtra on new macOS
        // https://developer.apple.com/documentation/SwiftUI/MenuBarExtra
        let menuItem = NSMenuItem()
        menuItem.view = view

        let menu = NSMenu()
        menu.addItem(menuItem)
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.statusItem?.menu = menu
        self.statusItem?.button?.image = NSImage(named: "MenuIcon")
    }
}
