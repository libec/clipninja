import AppKit
import ClipNinjaPackage
import SwiftUI

protocol WindowsFactory {
    func make(appWindow: AppWindow) -> StyledWindow
}

final class WindowsFactoryImpl: WindowsFactory {
    private let instanceProvider: InstanceProvider
    private let keyboardObserver: SystemKeyboardObserver

    init(instanceProvider: InstanceProvider, keyboardObserver: SystemKeyboardObserver) {
        self.instanceProvider = instanceProvider
        self.keyboardObserver = keyboardObserver
    }

    func make(appWindow: AppWindow) -> StyledWindow {
        switch appWindow {
        case .clips:
            makeClipsWindow()
        case .settings:
            makeSettingsWindow()
        case .tutorial:
            makeTutorialWindow()
        }
    }

    private func makeClipsWindow() -> ClipboardWindow {
        let window = ClipboardWindow(keyboardController: keyboardObserver)
        let clipsView = instanceProvider.resolve(AnyView.self, name: AssemblyKeys.clipboardView.rawValue)
        window.contentView = NSHostingView(rootView: clipsView)
        return window
    }

    private func makeSettingsWindow() -> SettingsWindow {
        let window = SettingsWindow()
        let settingsView = instanceProvider.resolve(AnyView.self, name: AssemblyKeys.settingsView.rawValue)
        window.contentView = NSHostingView(rootView: settingsView)
        return window
    }

    private func makeTutorialWindow() -> TutorialWindow {
        let window = TutorialWindow()
        let settingsView = instanceProvider.resolve(AnyView.self, name: AssemblyKeys.tutorialView.rawValue)
        window.contentView = NSHostingView(rootView: settingsView)
        return window
    }
}
