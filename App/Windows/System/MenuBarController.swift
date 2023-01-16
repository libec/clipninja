import AppKit
import ClipNinjaPackage

final class MenuBarController: NSObject {

    private let navigation: Navigation
    private var statusItem: NSStatusItem?

    init(navigation: Navigation) {
        self.navigation = navigation
    }

    func setupMenuBar() {
        let clipboardsItem = NSMenuItem(title: "Clipboards", action: #selector(showClipboards), keyEquivalent: "")
        clipboardsItem.target = self
        let settingsItem = NSMenuItem(title: "Settings", action: #selector(showSettings), keyEquivalent: "")
        settingsItem.target = self
        let tutorialItem = NSMenuItem(title: "🚧 Tutorial 🚧", action: #selector(showTutorial), keyEquivalent: "")
        tutorialItem.target = self
        let quitItem = NSMenuItem(title: "Quit", action: #selector(exitApp), keyEquivalent: "")
        quitItem.target = self

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
}
