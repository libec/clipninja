import SwiftUI

struct SettingsView<ViewModel: SettingsViewModel>: View {

    @StateObject var viewModel: ViewModel
    private let recordShortcutView: AnyView
    @State private var launchAtLogin: Bool = false

    private typealias L11n = R.Settings

    init(viewModel: ViewModel, recordShortcutView: AnyView) {
        self.recordShortcutView = recordShortcutView
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    private var accessibilityUrl: URL? {
        URL(string: L11n.accessibilityUrl)
    }

    private var isTrustedToPasteDirecly: Bool {
        AXIsProcessTrusted()
    }

    var body: some View {
        VStack(spacing: 15) {
            Toggle(L11n.pasteDirectly, isOn: Binding(get: {
                viewModel.pasteDirectlySettings
            }, set: { _, _ in
                viewModel.onEvent(.settingsEvent(.togglePasteDirectly))
            }))
            Text("\(L11n.accesibilityPermission) \(isTrustedToPasteDirecly ? "👍" : "👎")")
            Button(L11n.openAccessibilitySettings) {
                if let url = accessibilityUrl {
                    NSWorkspace.shared.open(url)
                }
            }
            recordShortcutView
            Toggle("\(L11n.wip) \(L11n.launchAtLogin)", isOn: $launchAtLogin)
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
