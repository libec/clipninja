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

    init(navigation: Navigation, windowFactory: WindowsFactory) {
        self.navigation = navigation
        self.windowFactory = windowFactory
    }

    private func activate(appWindow: AppWindow, modalWindow: AppWindow?) {
        let window = windowFactory.make(appWindow: appWindow)
        window.makeKeyAndOrderFront(nil)
        window.orderFrontRegardless()
        NSApp.activate(ignoringOtherApps: true)

        if let modalWindow {
            window.beginSheet(windowFactory.make(appWindow: modalWindow))
        }
    }

    private func showModal(modalWindow: AppWindow) {
        NSApp.keyWindow?.beginSheet(windowFactory.make(appWindow: modalWindow))
    }

    func openFirstWindow() {
        // TODO: - Setup onboarding stuff and whatnot
        activate(appWindow: .clips, modalWindow: nil)
    }

    func startNavigation() {
        navigation.navigationEvent
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] event in
                switch event {
                case .hideApp:
                    NSApp.hide(nil)
                    self.closeClipsWindows()
                case .showClipboard:
                    self.closeClipsWindows()
                    self.activate(appWindow: .clips, modalWindow: nil)
                case .showSettings:
                    self.closeClipsWindows()
                    self.activate(appWindow: .settings, modalWindow: nil)
                case .showTutorialOnClips:
                    // TODO: - Find some other non-hacky way
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: {
                        self.showModal(modalWindow: .tutorial)
                    })
                case .showTutorial:
                    self.closeClipsWindows()
                    self.activate(appWindow: .tutorial, modalWindow: nil)
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
