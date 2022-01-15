import SwiftUI
import Swinject
import Settings
import Clipboard
import Navigation
import InstanceProvider
import Combine

public final class ApplicationAssembly {

    private var coreAssemblies: [Assembly] {
        [
            InstanceProviderAssembly(),
            SettingsAssembly(),
            ClipboardAssembly(),
        ]
    }

    private var appSpecificAssemblies: [Assembly] {
        [
            NavigationAssembly()
        ]
    }

    public func resolveDependencyGraph<Instance>() -> Instance {
        let assembler = Assembler()
        assembler.apply(assemblies: coreAssemblies)
        assembler.apply(assemblies: appSpecificAssemblies)
        return assembler.resolver.resolve(Instance.self)!
    }
}


@main
struct ClipNinjaApp: App {

    @State private var statusItem: NSStatusItem?

    let applicationAssembly = ApplicationAssembly()
    @ObservedObject private var windowsState = AppWindowsState()

    var body: some Scene {
        WindowGroup {
            if !windowsState.mainViewHidden {
                let instanceProvider: InstanceProvider = applicationAssembly.resolveDependencyGraph()
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
        //        .windowStyle(HiddenTitleBarWindowStyle())
    }

    private func setupSettings(instanceProvider: InstanceProvider) {
        guard statusItem == nil else { return }

        let settingsView = instanceProvider.resolve(SettingsView.self)
            .environmentObject(windowsState)
        let view = NSHostingView(rootView: settingsView)

        view.frame = NSRect(x: 0, y: 0, width: 200, height: 200)

        let menuItem = NSMenuItem()
        menuItem.view = view

        let menu = NSMenu()
        menu.addItem(menuItem)
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.statusItem?.menu = menu
        self.statusItem?.button?.title = "ClipNinja"
    }
}
