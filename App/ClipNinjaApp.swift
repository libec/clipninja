import SwiftUI
import Swinject
import Settings
import Clipboard
import InstanceProvider

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
    @State private var hidden = false

    var body: some Scene {
        WindowGroup {
            if !hidden {
            let instanceProvider: InstanceProvider = applicationAssembly.resolveDependencyGraph()
                let clipboardView = instanceProvider.resolve(ClipboardView.self, argument: $hidden)
            clipboardView
                .frame(width: 400, height: 400)
                .onAppear {
                    NSApp.activate(ignoringOtherApps: true)
                    setupSettings(instanceProvider: instanceProvider)
                }
            }
        }
        //        .windowStyle(HiddenTitleBarWindowStyle())
    }

    private func setupSettings(instanceProvider: InstanceProvider) {
        let view = NSHostingView(rootView: instanceProvider.resolve(SettingsView.self))

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
