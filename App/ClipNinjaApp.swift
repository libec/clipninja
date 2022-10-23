import SwiftUI
import Combine
import ClipNinjaPackage

class AppDelegate: NSObject, NSApplicationDelegate {

    private var window: NSWindow!

    private var statusItem: NSStatusItem?
    private let keyboardController: KeyboardController
    private var subscriptions = Set<AnyCancellable>()

    private let applicationAssembly: ApplicationAssembly
    private let instanceProvider: InstanceProvider
    private let navigation: Navigation

    override init() {
        self.keyboardController = KeyboardController()
        let keyboardHandlingAssembly = KeyboardHandlingAssembly(keyboardNotifier: keyboardController)
        self.applicationAssembly = ApplicationAssembly(systemAssemblies: [keyboardHandlingAssembly])
        self.instanceProvider = applicationAssembly.resolveDependencyGraph()
        self.navigation = instanceProvider.resolve(Navigation.self)
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
        setupNavigation()
        window.contentView = NSHostingView(rootView: clipsView)
        activate(window: window)
        window.center()
    }

    private func setupNavigation() {
        navigation.navigationEvent.sink { event in
            switch event {
            case .hideApp:
                NSApp.hide(nil)
            case .showClipboard:
                NSApp.activate(ignoringOtherApps: true)
            case .showSettings:
                print("show settings")
            }
        }.store(in: &subscriptions)
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

    func activate(window: NSWindow) {
        window.makeKeyAndOrderFront(nil)
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
        navigation.handle(navigationEvent: .showClipboard)
    }

    @objc
    func exitApp() {
        NSApp.terminate(self)
    }

    @objc
    func showSettings() {
        navigation.handle(navigationEvent: .showSettings)
    }

    @objc
    func showTutorial() {
        print("🚧🚧: Show onboarding")
    }
}
