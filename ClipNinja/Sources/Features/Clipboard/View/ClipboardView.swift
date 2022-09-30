import SwiftUI
import Combine

struct ClipboardView<ViewModel: ClipboardViewModel>: View {

    private let navigation: Navigation
    @StateObject var viewModel: ViewModel

    init(
        viewModel: ViewModel,
        navigation: Navigation
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.navigation = navigation
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ForEach(0..<viewModel.clipPreviews.count, id: \.self) { row in
                    ClipboardRow(
                        text: viewModel.clipPreviews[row].previewText,
                        shortcut: "\(row)",
                        pinned: viewModel.clipPreviews[row].pinned,
                        selected: viewModel.clipPreviews[row].selected
                    )
                }
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height,
                alignment: .center
            )
        }
        .background(KeyEventHandling(onKeyPress: { keyPress in

            switch keyPress {
            case .numeric(let numericKey):
                viewModel.onEvent(.number(number: numericKey.mapToIndex()))
            case .key(let key):
                switch key {
                case .down:
                    viewModel.onEvent(.down)
                case .up:
                    viewModel.onEvent(.up)
                case .right:
                    viewModel.onEvent(.right)
                case .left:
                    viewModel.onEvent(.left)
                case .backspace:
                    viewModel.onEvent(.delete)
                case .enter:
                    viewModel.onEvent(.enter)
                case .space:
                    viewModel.onEvent(.space)
                case .esc:
                    print("FOO ESCAPE YOOOO")
                case .w:
                    break
                }
            }
        }))
        .onAppear(perform: viewModel.subscribe)
    }
}

struct ClipboardView_Previews: PreviewProvider {

    class NavigationPreview: Navigation {
        var showClipboard: AnyPublisher<Bool, Never> {
            Empty().eraseToAnyPublisher()
        }
    }

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
            texts.map {
                ClipPreview(
                    previewText: $0,
                    selected: texts[4] == $0,
                    pinned: texts.firstIndex(of: $0)! < 2,
                    shortcutNumber: "\($0)"
                )
            }
        }
        
        func onEvent(_ input: ClipboardViewModelEvent) { }
        func subscribe() { }
    }

    static var previews: some View {
        ClipboardView(
            viewModel: ClipboardViewModelPreview(),
            navigation: NavigationPreview()
        )
    }

}
