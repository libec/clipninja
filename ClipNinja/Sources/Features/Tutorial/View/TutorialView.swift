import SwiftUI

struct TutorialView<ViewModel: TutorialViewModel>: View {

    @StateObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            tutorialView
                .font(.title)
            Spacer()
            Button {
                viewModel.onEvent(.tutorial(.dismiss))
            } label: {
                Text("OKay")
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
        .onAppear { viewModel.onEvent(.lifecycle(.appear)) }
    }

    private var tutorialView: some View {
        switch viewModel.tutorial {
        case .welcome:
            return Text("Welcome to this app!")
        case .pasting:
            return Text("Paste stuff and see what what, YO!")
        case .none:
            return Text("")
        }
    }
}

class ViewModelStub: TutorialViewModel {
    func onEvent(_ event: TutorialEvent) { }
    var tutorial: Tutorial? = .welcome
}

struct TutorialView_Previews: PreviewProvider {

    static var previews: some View {
        TutorialView(viewModel: ViewModelStub())
            .frame(width: 450, height: 400)
    }
}
