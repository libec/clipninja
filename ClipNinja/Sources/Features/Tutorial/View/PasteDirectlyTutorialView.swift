import SwiftUI

struct PasteDirectlyTutorialView: View {

    var body: some View {
        content
            .background(Colors.backgroundColor)
    }

    var content: some View {
        VStack(spacing: 30) {
            heading
            tutorial
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(15)
    }

    private var heading: some View {
        TitleText("DONE!")
            .padding(.top, 15)
    }

    private var tutorial: some View {
        VStack(spacing: 25) {
            HStack(spacing: 0) {
                DescriptionText("Your ")
                HighlightedDescriptionText("CLIP")
                DescriptionText(" is in your pasteboard.")
            }

            HStack(spacing: 0) {
                HighlightedDescriptionText("PASTE DIRECTLY")
                DescriptionText(" option is in the settings!")
            }
        }
    }
}
