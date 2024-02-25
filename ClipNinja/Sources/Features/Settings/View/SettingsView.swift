import SwiftUI

struct SettingsView<ViewModel: SettingsViewModel>: View {
    private let recordShortcutView: AnyView

    @StateObject var viewModel: ViewModel

    init(viewModel: ViewModel, recordShortcutView: AnyView) {
        self.recordShortcutView = recordShortcutView
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            recordShortcutView
            launchAtLogin
            pasteDirectly
            movePastedToTop
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Colors.backgroundColor)
        .foregroundColor(Colors.defaultTextColor)
        .onAppear { viewModel.onEvent(.lifecycle(.appear)) }
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
                    .popover(isPresented: viewModel.showPasteDirectlyHint.binding {
                        viewModel.onEvent(.settingsEvent(.showPasteDirectlyHint))
                    }, content: {
                        ZStack {
                            Colors.backgroundColor
                            PasteDirectlyView(
                                showSettings: {
                                    viewModel.onEvent(.settingsEvent(.showAccessibilitySettings))
                                }
                            )
                        }
                    })
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

    var movePastedToTop: some View {
        Toggle(R.Settings.movePastedClipToTop, isOn: viewModel.movePastedClipToTop.binding {
            viewModel.onEvent(.settingsEvent(.toggleMovePastedToTop))
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
        let movePastedClipToTop = true

        func onEvent(_: SettingsEvent) {}
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
