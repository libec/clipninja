import SwiftUI

struct TutorialView<ViewModel: TutorialViewModel>: View {

    @StateObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("This is where some serious shit will unravel")
                .font(.title)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
    }
}

class ViewModelStub: TutorialViewModel {
    func onEvent(_ event: TutorialEvent) { }
}

struct TutorialView_Previews: PreviewProvider {

    static var previews: some View {
        TutorialView(viewModel: ViewModelStub())
            .frame(width: 450, height: 400)
    }
}
