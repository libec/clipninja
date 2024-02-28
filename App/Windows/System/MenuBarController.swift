import AppKit
import ClipNinjaPackage
import Combine

final class MenuBarController: NSObject {
    private let navigation: Navigation
    private var statusItem: NSStatusItem?

    private weak var controlsItem: NSMenuItem?
    private var subscriptions = Set<AnyCancellable>()

    init(navigation: Navigation) {
        self.navigation = navigation
    }

    func setupMenuBar() {
        let clipboardsItem = NSMenuItem(title: Strings.MenuItems.clips, action: #selector(showClipboards), keyEquivalent: "")
        clipboardsItem.target = self
        let settingsItem = NSMenuItem(title: Strings.MenuItems.settings, action: #selector(showSettings), keyEquivalent: "")
        settingsItem.target = self
        let controlsItem = NSMenuItem(title: Strings.MenuItems.controls, action: #selector(showControls), keyEquivalent: "")
        controlsItem.target = self
        self.controlsItem = controlsItem
        let quitItem = NSMenuItem(title: Strings.MenuItems.quit, action: #selector(exitApp), keyEquivalent: "")
        quitItem.target = self

        let menu = NSMenu()
        menu.addItem(clipboardsItem)
        menu.addItem(settingsItem)
        menu.addItem(controlsItem)
        menu.addItem(.separator())
        menu.addItem(quitItem)

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.menu = menu
        statusItem?.button?.image = NSImage(named: "MenuIcon")
        subscribeNavigation()
    }

    private func subscribeNavigation() {
        navigation.navigationEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .showTutorial:
                    self?.controlsItem?.target = nil
                case .hideTutorial:
                    self?.controlsItem?.target = self
                default:
                    break
                }
            }.store(in: &subscriptions)
    }

    @objc
    func showClipboards() {
        navigation.handle(navigationEvent: .showClipboard)
    }

    @objc
    func exitApp() {
        NSApp.terminate(nil)
    }

    @objc
    func showSettings() {
        navigation.handle(navigationEvent: .showSettings)
    }

    @objc
    func showControls() {
        navigation.handle(navigationEvent: .showAppUsage)
    }
}
