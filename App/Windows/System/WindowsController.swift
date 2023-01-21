import SwiftUI
import Combine
import ClipNinjaPackage

enum AppWindow {
    case clips
    case settings
    case tutorial
}

enum AppModals {
    case onboarding
    case pasteDirectly
}

class WindowsController {

    private let navigation: Navigation
    private let windowFactory: WindowsFactory
    private var subscriptions = Set<AnyCancellable>()

    private var activeWindow: NSWindow?
    private var modalWindow: NSWindow?

    init(navigation: Navigation, windowFactory: WindowsFactory) {
        self.navigation = navigation
        self.windowFactory = windowFactory
    }

    private func activate(appWindow: AppWindow) {
        let window = windowFactory.make(appWindow: appWindow)
        window.makeKeyAndOrderFront(nil)
        window.orderFrontRegardless()
        activeWindow = window
        NSApp.activate(ignoringOtherApps: true)
    }

    private func showModal(modalWindow: AppWindow) {
        let modalWindow = self.windowFactory.make(appWindow: modalWindow)
        self.modalWindow = modalWindow
        activeWindow?.beginSheet(modalWindow)
    }

    func openFirstWindow() {
        activate(appWindow: .clips)
    }

    func hideModal() {
        if let modalWindow {
            activeWindow?.endSheet(modalWindow)
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
                switch event {
                case .hideApp:
                    NSApp.hide(nil)
                    self.closeClipsWindows()
                case .showClipboard:
                    self.closeClipsWindows()
                    self.activate(appWindow: .clips)
                case .showSettings:
                    self.activate(appWindow: .settings)
                case .showAppUsage:
                    self.closeClipsWindows()
                    self.activate(appWindow: .tutorial)
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

    private func closeClipsWindows() {
        NSApp.windows.filter { $0 is ClipboardWindow }.forEach { $0.close() }
    }
}
