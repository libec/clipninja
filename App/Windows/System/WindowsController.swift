import SwiftUI
import Combine
import ClipNinjaPackage

enum AppWindow {
    case clips
    case settings
}

class WindowsController {

    private let navigation: Navigation
    private let windowFactory: WindowsFactory
    private var subscriptions = Set<AnyCancellable>()

    init(navigation: Navigation, windowFactory: WindowsFactory) {
        self.navigation = navigation
        self.windowFactory = windowFactory
    }

    private func activate(appWindow: AppWindow) {
        let window = windowFactory.make(appWindow: appWindow)
        window.makeKeyAndOrderFront(nil)
        window.orderFrontRegardless()
        NSApp.activate(ignoringOtherApps: true)
    }

    func openFirstWindow() {
        // TODO: - Setup onboarding stuff and whatnot
        activate(appWindow: .clips)
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
                    self.activate(appWindow: .clips)
                case .showSettings:
                    self.closeClipsWindows()
                    self.activate(appWindow: .settings)
                case .showSystemSettings:
                    let accessibilityUrl = "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
                    guard let url = URL(string: accessibilityUrl) else {
                        log(message: "Failed to create accessibility URL")
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
