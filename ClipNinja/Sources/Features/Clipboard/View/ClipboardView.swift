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
            .padding(10)
            .background(KeyEventHandling(onKeyPress: onKeyPress(keyPress:)))
            .onAppear { viewModel.onEvent(.lifecycle(.appear)) }
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
        .background(Colors.factory.backgroundColor)
    }

    private var pages: some View {
        HStack {
            ForEach(0..<viewModel.totalPages, id: \.self) { index in
                (index == viewModel.shownPage ? Colors.factory.prominent : Colors.factory.selectedBackgroundColor)
                        .frame(width: 50, height: 5, alignment: .center)
                        .clipShape(Capsule())

            }
        }
    }

    private func onKeyPress(keyPress: KeyboardShortcuts.Key) {
        switch keyPress {
        case .downArrow:
            viewModel.onEvent(.keyboard(.down))
        case .upArrow:
            viewModel.onEvent(.keyboard(.up))
        case .rightArrow:
            viewModel.onEvent(.keyboard(.right))
        case .leftArrow:
            viewModel.onEvent(.keyboard(.left))
        case .delete:
            viewModel.onEvent(.keyboard(.delete))
        case .keypadEnter, .`return`:
            viewModel.onEvent(.keyboard(.enter))
        case .space:
            viewModel.onEvent(.keyboard(.space))
        case .escape:
            viewModel.onEvent(.keyboard(.escape))
        case .keypad1, .one:
            viewModel.onEvent(.keyboard(.number(number: 1)))
        case .keypad2, .two:
            viewModel.onEvent(.keyboard(.number(number: 2)))
        case .keypad3, .three:
            viewModel.onEvent(.keyboard(.number(number: 3)))
        case .keypad4, .four:
            viewModel.onEvent(.keyboard(.number(number: 4)))
        case .keypad5, .five:
            viewModel.onEvent(.keyboard(.number(number: 5)))
        case .keypad6, .six:
            viewModel.onEvent(.keyboard(.number(number: 6)))
        case .keypad7, .seven:
            viewModel.onEvent(.keyboard(.number(number: 7)))
        case .keypad8, .eight:
            viewModel.onEvent(.keyboard(.number(number: 8)))
        case .keypad9, .nine:
            viewModel.onEvent(.keyboard(.number(number: 9)))
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
        ).preferredColorScheme(.light)

        ClipboardView(
            viewModel: ClipboardViewModelPreview()
        ).preferredColorScheme(.dark)
    }

}
