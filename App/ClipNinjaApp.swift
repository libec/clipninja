import SwiftUI
import Combine
import ClipNinja

class AppDelegate: NSObject, NSApplicationDelegate {

}

@main
struct ClipNinjaApp: App {

    @State private var statusItem: NSStatusItem?
    @ObservedObject private var windowsState: AppWindowsState
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    private let applicationAssembly = ApplicationAssembly()
    private let instanceProvider: InstanceProvider

    init() {
        self.instanceProvider = applicationAssembly.resolveDependencyGraph()
        self.windowsState = AppWindowsState(navigation: instanceProvider.resolve(Navigation.self))

    }

    var body: some Scene {
        WindowGroup {
            if windowsState.showClipboard {
                let clipboardView = instanceProvider.resolve(ClipboardView.self)
                clipboardView
                    .frame(width: 400, height: 400)
                    .onAppear {
                        NSApp.activate(ignoringOtherApps: true)
                        setupSettings(instanceProvider: instanceProvider)
                    }
                    .environmentObject(windowsState)
            }
        }
        .windowStyle(HiddenTitleBarWindowStyle())

    }

    private func setupSettings(instanceProvider: InstanceProvider) {
        guard statusItem == nil else { return }

        let settingsView = instanceProvider.resolve(SettingsView.self)
            .environmentObject(windowsState)
        let view = NSHostingView(rootView: settingsView)

        view.frame = NSRect(x: 0, y: 0, width: 400, height: 200)

        let menuItem = NSMenuItem()
        menuItem.view = view

        let menu = NSMenu()
        menu.addItem(menuItem)
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.statusItem?.menu = menu
        self.statusItem?.button?.title = "ClipNinja"
    }
}
