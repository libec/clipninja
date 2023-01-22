import SwiftUI

struct PasteDirectlyView: View {
    private let showSettings: () -> Void

    init(showSettings: @escaping () -> Void) {
        self.showSettings = showSettings
    }


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
        HStack {
            TitleText("PASTE DIRECTLY")
        }
        .padding(.top, 15)
    }

    private var tutorial: some View {
        VStack(spacing: 10) {
            DescriptionText("This feature pastes the text directly to the underlying app.")
            DescriptionText("Turning it on requires accessibility permission from the system.")
            DescriptionText("You can grant it in:")

            HStack(spacing: 10) {
                HighlightedDescriptionText("System preferences")
                settingsSeparator()
                HighlightedDescriptionText("Privacy & Security")
                settingsSeparator()
                HighlightedDescriptionText("Accessibility")
            }

            HStack(spacing: 0) {
                DescriptionText("Shortcut:")
                PulsatingButton(title: "Take me there") {
                    showSettings()
                }
            }
            DescriptionText("Click the plus button, authenticate and add ClipNinja and turn the toggle ON.")
            DescriptionText("And that's it.")
        }
    }

    private func settingsSeparator() -> some View {
        Image(systemName: "arrowshape.right")
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(Colors.defaultTextColor)
    }
}

struct PasteDirectlyView_Previews: PreviewProvider {

    static var previews: some View {
        PasteDirectlyView(showSettings: {})
            .frame(width: 400, height: 250)
    }
}
