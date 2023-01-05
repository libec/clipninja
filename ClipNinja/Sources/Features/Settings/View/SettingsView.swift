import SwiftUI

struct SettingsView<ViewModel: SettingsViewModel>: View {

    private let recordShortcutView: AnyView

    @StateObject var viewModel: ViewModel


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
        .sheet(isPresented: viewModel.showPasteDirectlyHint.binding {
            viewModel.onEvent(.settingsEvent(.showPasteDirectlyHint))
        }) {
            ZStack {
                Colors.backgroundColor
                PasteDirectlyView()
            }
        }
    }

    var pasteDirectly: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Toggle(R.Settings.PasteDirectly.settingLabel, isOn: viewModel.pasteDirectly.binding {
                    viewModel.onEvent(.settingsEvent(.togglePasteDirectly))
                })

                Image(systemName: "info.circle.fill")
                    .onTapGesture {
                        viewModel.onEvent(.settingsEvent(.showPasteDirectlyHint))
                    }

            }
            Text(R.Settings.PasteDirectly.featureDescription)
                .font(.callout)
                .foregroundStyle(.gray)
        }
    }

    var launchAtLogin: some View {
        Toggle(R.Settings.launchAtLogin, isOn: viewModel.launchAtLogin.binding {
            viewModel.onEvent(.settingsEvent(.toggleLaunchAtLogin))
        })
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
        let showPasteDirectlyHint = false

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
