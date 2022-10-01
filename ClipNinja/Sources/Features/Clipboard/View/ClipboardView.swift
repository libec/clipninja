import SwiftUI
import Combine
import KeyboardShortcuts

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
            SettingsView()
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
            navigation.hide()
        case .keypad1, .one:
            log(message: "one pressed")
        default:
            log(message: "unhandled key press: \(keyPress)")
        }
    }
}

struct ClipboardView_Previews: PreviewProvider {

    class NavigationPreview: Navigation {
        func subscribe() { }
        func hide() { }
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
