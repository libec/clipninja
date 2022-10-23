import SwiftUI

struct SettingsView<ViewModel: SettingsViewModel>: View {

    @StateObject var viewModel: ViewModel

    private let recordShortcutView: AnyView
    @State private var launchAtLogin: Bool = false

    init(viewModel: ViewModel, recordShortcutView: AnyView) {
        self.recordShortcutView = recordShortcutView
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    private var accessibilityUrl: URL? {
        let privacyUrlString = "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
        return URL(string: privacyUrlString)
    }

    private var isTrustedToPasteDirecly: Bool {
        AXIsProcessTrusted()
    }

    var body: some View {
        VStack(spacing: 15) {
            Toggle("Paste Directly", isOn: Binding(get: {
                viewModel.pasteDirectlySettings
            }, set: { _, _ in
                viewModel.onEvent(.settingsEvent(.togglePasteDirectly))
            }))
            Text("Process is trusted \(isTrustedToPasteDirecly ? "true" : "false")")
            Button("Open Privacy Settings") {
                if let url = accessibilityUrl {
                    NSWorkspace.shared.open(url)
                }
            }
            recordShortcutView
            Toggle("🚧🚧🚧 Launch at login", isOn: $launchAtLogin)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Colors.backgroundColor)
        .foregroundColor(Colors.defaultTextColor)
        .onAppear { viewModel.onEvent(.lifecycle(.appear)) }
    }
}

struct SettingsView_Previews: PreviewProvider {

    static var recordShortcutView: AnyView {
        AnyView(
            Color.green
                .frame(width: 200, height: 80)
        )
    }

    class ViewModelStub: SettingsViewModel {

        let pasteDirectlySettings = true
        let allowedToPaste = false

        func onEvent(_ event: SettingsViewModelEvent) { }
    }

    private static var settingsView: some View {
        SettingsView(viewModel: ViewModelStub(), recordShortcutView: recordShortcutView)
            .frame(width: 400, height: 250)
    }

    static var previews: some View {
        settingsView
            .preferredColorScheme(.light)

        settingsView
            .preferredColorScheme(.dark)
    }
}
