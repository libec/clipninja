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

        let clipboardsItem = NSMenuItem(title: "Clipboards", action: #selector(showClipboards), keyEquivalent: "")
        let settingsItem = NSMenuItem(title: "🚧 Settings 🚧", action: #selector(showSettings), keyEquivalent: "")
        let tutorialItem = NSMenuItem(title: "🚧 Tutorial 🚧", action: #selector(showTutorial), keyEquivalent: "")
        let quitItem = NSMenuItem(title: "Quit", action: #selector(exitApp), keyEquivalent: "")

        let menu = NSMenu()
        menu.addItem(clipboardsItem)
        menu.addItem(settingsItem)
        menu.addItem(tutorialItem)
        menu.addItem(.separator())
        menu.addItem(quitItem)

        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.statusItem?.menu = menu
        self.statusItem?.button?.image = NSImage(named: "MenuIcon")
    }

    @objc
    func showClipboards() {
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc
    func exitApp() {
        NSApp.terminate(self)
    }

    @objc
    func showSettings() {
        print("🚧🚧: Show settings")
    }

    @objc
    func showTutorial() {
        print("🚧🚧: Show settings")
    }
}
