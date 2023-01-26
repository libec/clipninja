import SwiftUI
import Combine
import ClipNinjaPackage

enum AppWindow {
    case clips
    case settings
    case tutorial
}

class WindowsController {

    private let navigation: Navigation
    private let windowFactory: WindowsFactory
    private var subscriptions = Set<AnyCancellable>()

    private weak var activeWindow: NSWindow?
    private weak var modalWindow: NSWindow?

    init(navigation: Navigation, windowFactory: WindowsFactory) {
        self.navigation = navigation
        self.windowFactory = windowFactory
    }

    private func activate(appWindow: AppWindow) {
        let window = windowFactory.make(appWindow: appWindow)
        window.makeKeyAndOrderFront(nil)
        window.orderFrontRegardless()
        activeWindow = window
        window.centerIfShownTheFirstTime()
        NSApp.activate(ignoringOtherApps: true)
    }

    private func showModal(modalWindow: AppWindow) {
        if self.modalWindow == nil {
            let modalWindow = self.windowFactory.make(appWindow: modalWindow)
            self.modalWindow = modalWindow
            activeWindow?.beginSheet(modalWindow)
        }
    }

    func openFirstWindow() {
        activate(appWindow: .clips)
    }

    private func hideModal() {
        if let modalWindow {
            activeWindow?.endSheet(modalWindow)
            NSApp.stopModal()
            self.modalWindow = nil
        }
    }

    func startNavigation() {

        let delayedEvents = navigation.navigationEvent
            .filter(\.delayedEvent)
            .throttle(for: 0.3, scheduler: RunLoop.main, latest: true)

        let immediateEvents = navigation.navigationEvent
            .filter(\.immediateEvent)

        delayedEvents.merge(with: immediateEvents)
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] event in
                log(message: "NavigationEvent: \(event)", category: .windows)
                log(message: "App windows", category: .windows)
                NSApp.windows.forEach { window in
                    log(message: "Window: \(window)", category: .windows)
                }
                switch event {
                case .hideApp:
                    NSApp.hide(nil)
                case .showClipboard:
                    self.closeSettingsWindows()
                    self.closeClipsWindows()
                    self.activate(appWindow: .clips)
                case .showSettings:
                    self.closeSettingsWindows()
                    self.closeClipsWindows()
                    self.activate(appWindow: .settings)
                case .showAppUsage:
                    let clipboardWindows = NSApp.windows.filter { $0 is ClipboardWindow }
                    if let clipboardWindow = clipboardWindows.first {
                        clipboardWindow.makeKeyAndOrderFront(nil)
                        self.activeWindow = clipboardWindow
                    } else {
                        self.activate(appWindow: .clips)
                    }
                    self.showModal(modalWindow: .tutorial)
                case .showTutorial:
                    self.showModal(modalWindow: .tutorial)
                case .hideTutorial:
                    self.hideModal()
                case .showSystemSettings:
                    let accessibilityUrl = Strings.Settings.PasteDirectly.accessibilityUrl
                    guard let url = URL(string: accessibilityUrl) else {
                        log(message: "Failed to create accessibility URL", category: .main)
                        return
                    }
                    NSWorkspace.shared.open(url)
                }
            }.store(in: &subscriptions)
    }

    func resignActive() {
        closeClipsWindows()
    }

    private func closeAppUsageWindows() {
        NSApp.windows.filter { $0 is TutorialWindow }.forEach {
            $0.close()
        }
    }

    private func closeSettingsWindows() {
        NSApp.windows.filter { $0 is SettingsWindow }.forEach {
            $0.close()
        }
    }

    private func closeClipsWindows() {
        hideModal()
        NSApp.windows.filter { $0 is ClipboardWindow }.forEach {
            $0.close()
        }
    }
}
