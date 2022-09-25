import SwiftUI
import Combine

public struct ClipboardView: View {

    private let navigation: Navigation
    let viewModel: any ClipboardViewModel

    public init(
        viewModel: any ClipboardViewModel,
        navigation: Navigation
    ) {
        self.viewModel = viewModel
        self.navigation = navigation
    }

    public var body: some View {
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
        .background(KeyEventHandling())
    }

    func color(for row: Int, column: Int) -> some View {
        let white = Color(red: 1, green: 1, blue: 1)
        let black = Color(red: 0, green: 0, blue: 0)
        let oddRow = row % 2 == 0
        let oddColumn = column % 2 == 0
        let shouldUseBlack = (oddRow && oddColumn) || (!oddRow && !oddColumn)
        return shouldUseBlack ? black : white
    }
}

struct ClipboardView_Previews: PreviewProvider {

    class NavigationPreview: Navigation {
        var showClipboard: AnyPublisher<Bool, Never> {
            Empty().eraseToAnyPublisher()
        }
    }

    class ClipboardViewModelPreview: ClipboardViewModel {

        var shownTab: Int = 0

        var totalTabs: Int = 5

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
        
        func onEvent(input: ClipboardViewModelInput) { }
    }

    static var previews: some View {
        ClipboardView(
            viewModel: ClipboardViewModelPreview(),
            navigation: NavigationPreview()
        )
    }

}
