import SwiftUI
import Combine

struct ClipboardView<ViewModel: ClipboardViewModel>: View {

    @StateObject var viewModel: ViewModel
    private let keyboardObserver: KeyboardObserver
    
    init(
        viewModel: ViewModel,
        keyboardNotifier: KeyboardObserver
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.keyboardObserver = keyboardNotifier
    }

    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onReceive(keyboardObserver.keyPress, perform: { keyPress in
                viewModel.onEvent(.keyboard(keyPress))
            })
            .onAppear { viewModel.onEvent(.lifecycle(.appear)) }
    }

    private var content: some View {
        viewModel.clipPreviews.isEmpty ? AnyView(EmptyClipboardView()) : AnyView(clipboardContent)
    }

    private var clipboardContent: some View  {
        VStack(spacing: 0) {
            ForEach(viewModel.clipPreviews) { preview in
                ClipboardRow(
                    text: preview.previewText,
                    shortcut: preview.shortcutNumber,
                    pinned: preview.pinned,
                    selected: preview.selected
                )
            }
            Spacer()

            pages.padding(.top).padding(.bottom)
        }
        .background(Colors.backgroundColor)
        .padding(10)
    }

    private var pages: some View {
        HStack {
            ForEach(0..<viewModel.totalPages, id: \.self) { index in
                (index == viewModel.shownPage ? Colors.prominent : Colors.selectedBackgroundColor)
                        .frame(width: 50, height: 5, alignment: .center)
                        .clipShape(Capsule())

            }
        }
    }
}

struct ClipboardView_Previews: PreviewProvider {

    class ClipboardViewModelPreview: ClipboardViewModel {

        var shownPage: Int = 0

        var totalPages: Int = 5

        private var texts: [String] = [
            "Lorem ipsum dolor",
            "sit amet, consectetur",
            "adipiscing elit. Donec nec",
            "maximus dolor. Quisque id",
            "eros vel enim tempus fermentum",
            "eget a lorem.",
            "Fusce a viverra lorem.",
            "Sed auctor, lorem eget",
            "semper facilisis, risus",
            "dui ornare dolor, sit amet"
        ]

        var clipPreviews: [ClipPreview] {
            texts.enumerated().map { index, clip in
                ClipPreview(
                    previewText: clip,
                    selected: texts[1] == clip,
                    pinned: index < 2,
                    shortcutNumber: "\(index)"
                )
            }
        }
        
        func onEvent(_ input: ClipboardViewModelEvent) { }
        func subscribe() { }
    }

    class KeyboardNotifierDummy: KeyboardObserver {
        var keyPress: AnyPublisher<KeyboardEvent, Never> {
            Just(.enter)
                .eraseToAnyPublisher()
        }
    }

    static var previews: some View {
        ClipboardView(
            viewModel: ClipboardViewModelPreview(),
            keyboardNotifier: KeyboardNotifierDummy()
        )
        .frame(width: 650, height: 550)
    }
}
