import SwiftUI
import Combine
import ClipNinjaPackage

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    private lazy var clipboardWindow: NSWindow = {
        let window = ClipboardWindow(keyboardController: keyboardObserver)
        let clipsView = instanceProvider.resolve(AnyView.self, name: AssemblyKeys.clipboardView.rawValue)
            .onAppear {
                NSApp.activate(ignoringOtherApps: true)
            }
        window.contentView = NSHostingView(rootView: clipsView)
        return window
    }()

    private lazy var settingsWindow: NSWindow = {
        let window = SettingsWindow()
        let settingsView = instanceProvider.resolve(
            AnyView.self,
            name: AssemblyKeys.settingsView.rawValue
        )
        window.contentView = NSHostingView(rootView: settingsView)
        return window
    }()

    private var statusItem: NSStatusItem?
    private let keyboardObserver: SystemKeyboardObserver
    private var subscriptions = Set<AnyCancellable>()

    private let applicationAssembly: ApplicationAssembly
    private let instanceProvider: InstanceProvider
    private let navigation: Navigation

    override init() {
        self.keyboardObserver = SystemKeyboardObserver()
        let keyboardHandlingAssembly = KeyboardHandlingAssembly(keyboardObserver: keyboardObserver)
        self.applicationAssembly = ApplicationAssembly(systemAssemblies: [keyboardHandlingAssembly, LaunchAtLoginAssembly()])
        self.instanceProvider = applicationAssembly.resolveDependencyGraph()
        self.navigation = instanceProvider.resolve(Navigation.self)
        super.init()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        launch()
    }

    func launch() {
        setupSettings()
        setupNavigation()
        activate(window: clipboardWindow)
        clipboardWindow.center()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { false }

    private func setupNavigation() {
        navigation.navigationEvent
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] event in
                switch event {
                case .hideApp:
                    NSApp.hide(nil)
                case .showClipboard:
                    self.settingsWindow.close()
                    self.activate(window: self.clipboardWindow)
                case .showSettings:
                    self.clipboardWindow.close()
                    self.activate(window: self.settingsWindow)
                case .showSystemAccessibilitySettings:
                    let accessibilityUrl = "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
                    guard let url = URL(string: accessibilityUrl) else {
                        log(message: "Failed to create accessibility URL")
                        return
                    }
                    NSWorkspace.shared.open(url)
                case .enableAccessibilitySettings:
                    instanceProvider.resolve(PasteCommand.self).paste()
                }
            }.store(in: &subscriptions)
    }

    func activate(window: NSWindow) {
        window.makeKeyAndOrderFront(nil)
        window.orderFrontRegardless()
        NSApp.activate(ignoringOtherApps: true)
    }

    private func setupSettings() {
        guard statusItem == nil else { return }

        let clipboardsItem = NSMenuItem(title: "Clipboards", action: #selector(showClipboards), keyEquivalent: "")
        let settingsItem = NSMenuItem(title: "Settings", action: #selector(showSettings), keyEquivalent: "")
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
        log(message: "🚧🚧: Show onboarding")
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
