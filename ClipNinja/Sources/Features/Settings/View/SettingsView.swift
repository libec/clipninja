import SwiftUI

struct SettingsView<ViewModel: SettingsViewModel>: View {

    @StateObject var viewModel: ViewModel
    private let recordShortcutView: AnyView

    private typealias L11n = R.Settings

    init(viewModel: ViewModel, recordShortcutView: AnyView) {
        self.recordShortcutView = recordShortcutView
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            recordShortcutView
            launchAtLogin
            pasteDirectly
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Colors.backgroundColor)
        .foregroundColor(Colors.defaultTextColor)
        .onAppear { viewModel.onEvent(.lifecycle(.appear)) }
    }

    var pasteDirectly: some View {
        VStack(alignment: .leading, spacing: 5) {
            Toggle(L11n.PasteDirectly.settingLabel, isOn: Binding(get: {
                viewModel.pasteDirectly
            }, set: { _, _ in
                viewModel.onEvent(.settingsEvent(.togglePasteDirectly))
            }))
            Text(L11n.PasteDirectly.featureDescription)
                .font(.callout)
                .foregroundStyle(.gray)
        }
    }

    var launchAtLogin: some View {
        Toggle("\(L11n.launchAtLogin)", isOn: Binding(
            get: {
                viewModel.launchAtLogin
            },
            set: { _, _ in
                viewModel.onEvent(.settingsEvent(.toggleLaunchAtLogin))
            }
        ))
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
        let pasteDirectly = false
        let launchAtLogin = false

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
