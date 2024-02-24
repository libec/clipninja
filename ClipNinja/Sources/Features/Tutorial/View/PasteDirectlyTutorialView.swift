import SwiftUI

// TODO: - Move texts to Strings.swift
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
        TitleText("READY!")
            .padding(.top, 15)
    }

    private var tutorial: some View {
        VStack(spacing: 25) {
            HStack(spacing: 0) {
                DescriptionText("You can now paste your ")
                HighlightedDescriptionText("CLIP.")
            }

            HStack(spacing: 0) {
                DescriptionText("Hint: Paste directly option is in the settings.")
            }
        }
    }
}
