import SwiftUI
import Combine
import ClipNinja

@main
struct ClipNinjaApp: App {

    @State private var window: NSWindow?
    @State private var statusItem: NSStatusItem?
    @ObservedObject private var windowsState: AppWindowsState

    private let applicationAssembly = ApplicationAssembly()
    private let instanceProvider: InstanceProvider

    init() {
        self.instanceProvider = applicationAssembly.resolveDependencyGraph()
        self.windowsState = AppWindowsState(navigation: instanceProvider.resolve(Navigation.self))
    }

    var body: some Scene {
        WindowGroup {
            if windowsState.showClipboard {
                clipboardView
            }
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }

    private var clipboardView: some View {
        let clipboardView = instanceProvider.resolve(AnyView.self, name: AssemblyKeys.clipboardView.rawValue)
        return clipboardView
            .frame(width: 600, height: 600)
            .onAppear {
                NSApp.activate(ignoringOtherApps: true)
                setupSettings(instanceProvider: instanceProvider)
                /*
                 TODO: - Replace with MenuBarExtra on new macOS
                    https://developer.apple.com/documentation/SwiftUI/MenuBarExtra
                 */

            }
            .environmentObject(windowsState)
            .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
                styleWindow()
            }
            .background(WindowAccessor(window: $window))
    }

    private func styleWindow() {
        window?.standardWindowButton(.zoomButton)?.isHidden = true
        window?.standardWindowButton(.miniaturizeButton)?.isHidden = true
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
