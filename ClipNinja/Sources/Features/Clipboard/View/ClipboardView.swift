import SwiftUI
import Combine
import KeyboardShortcuts

struct ClipboardView<ViewModel: ClipboardViewModel>: View {

    @StateObject var viewModel: ViewModel

    init(
        viewModel: ViewModel
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        clipboardContent
            .background(KeyEventHandling(onKeyPress: onKeyPress(keyPress:)))
            .onAppear(perform: viewModel.subscribe)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        .background(Color.black)
    }

    private var pages: some View {
        HStack {
            ForEach(0..<viewModel.totalPages, id: \.self) { index in
                Color(index == viewModel.shownPage ? .red : .white)
                    .frame(width: 50, height: 5, alignment: .center)
                    .clipShape(Capsule())
            }
        }
    }

    private func onKeyPress(keyPress: KeyboardShortcuts.Key) {
        switch keyPress {
        case .downArrow:
            viewModel.onEvent(.down)
        case .upArrow:
            viewModel.onEvent(.up)
        case .rightArrow:
            viewModel.onEvent(.right)
        case .leftArrow:
            viewModel.onEvent(.left)
        case .delete:
            viewModel.onEvent(.delete)
        case .keypadEnter, .`return`:
            viewModel.onEvent(.enter)
        case .space:
            viewModel.onEvent(.space)
        case .escape:
            viewModel.onEvent(.escape)
        case .keypad1, .one:
            viewModel.onEvent(.number(number: 1))
        case .keypad2, .two:
            viewModel.onEvent(.number(number: 2))
        case .keypad3, .three:
            viewModel.onEvent(.number(number: 3))
        case .keypad4, .four:
            viewModel.onEvent(.number(number: 4))
        case .keypad5, .five:
            viewModel.onEvent(.number(number: 5))
        case .keypad6, .six:
            viewModel.onEvent(.number(number: 6))
        case .keypad7, .seven:
            viewModel.onEvent(.number(number: 7))
        case .keypad8, .eight:
            viewModel.onEvent(.number(number: 8))
        case .keypad9, .nine:
            viewModel.onEvent(.number(number: 9))
        default:
            log(message: "unhandled key press: \(keyPress)")
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

    static var previews: some View {
        ClipboardView(
            viewModel: ClipboardViewModelPreview()
        )
    }

}
