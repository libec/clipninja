import SwiftUI

struct TutorialView<ViewModel: TutorialViewModel>: View {

    @StateObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            tutorialView
                .font(.title)

            VStack {
                HStack(spacing: 10) {
                    PulsatingButton(title: Strings.Tutorials.close) {
                        viewModel.onEvent(.tutorial(.dismiss))
                    }
                    if viewModel.showSettings {
                        PulsatingButton(title: Strings.Tutorials.showSettings) {
                            viewModel.onEvent(.tutorial(.showAppSettings))
                        }
                    }
                }
                .padding([.bottom, .leading])
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Colors.backgroundColor)
        .onAppear { viewModel.onEvent(.lifecycle(.appear)) }
    }

    private var tutorialView: some View {
        switch viewModel.tutorial {
        case .welcome:
            return AnyView(WelcomeTutorialView())
        case .pasting:
            return AnyView(PasteDirectlyTutorialView())
        case .none:
            return AnyView(AppUsageTutorialView())
        }
    }
}

struct TutorialView_Previews: PreviewProvider {

    class ViewModelStub: TutorialViewModel {
        func onEvent(_ event: TutorialEvent) { }
        var tutorial: Tutorial? = .welcome
        var showSettings: Bool = true
    }

    static var previews: some View {
        TutorialView(viewModel: ViewModelStub())
            .frame(width: 500, height: 400)
    }
}
