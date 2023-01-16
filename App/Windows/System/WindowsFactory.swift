import AppKit
import ClipNinjaPackage
import SwiftUI

protocol WindowsFactory {
    func make(appWindow: AppWindow) -> NSWindow
}

final class WindowsFactoryImpl: WindowsFactory {

    private let instanceProvider: InstanceProvider
    private let keyboardObserver: SystemKeyboardObserver

    init(instanceProvider: InstanceProvider, keyboardObserver: SystemKeyboardObserver) {
        self.instanceProvider = instanceProvider
        self.keyboardObserver = keyboardObserver
    }

    func make(appWindow: AppWindow) -> NSWindow {
        switch appWindow {
        case .clips:
            return makeClipsWindow()
        case .settings:
            return makeSettingsWindow()
        }
    }

    func makeClipsWindow() -> NSWindow {
        let window = ClipboardWindow(keyboardController: keyboardObserver)
        let clipsView = instanceProvider.resolve(AnyView.self, name: AssemblyKeys.clipboardView.rawValue)
            .onAppear {
                NSApp.activate(ignoringOtherApps: true)
            }
        window.contentView = NSHostingView(rootView: clipsView)
        return window
    }

    func makeSettingsWindow() -> NSWindow {
        let window = SettingsWindow()
        let settingsView = instanceProvider.resolve(
            AnyView.self,
            name: AssemblyKeys.settingsView.rawValue
        )
        window.contentView = NSHostingView(rootView: settingsView)
        return window
    }
}
