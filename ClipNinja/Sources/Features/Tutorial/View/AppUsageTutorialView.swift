import SwiftUI

// TODO: - Move texts to Strings.swift
struct AppUsageTutorialView: View {

    var body: some View {
        tutorial
            .padding(15)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Colors.backgroundColor)
    }

    private var tutorial: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 0) {
                HighlightedAlternatingText("ARROWS", alternativeTitle: "↑ ↓ ← →")
                DescriptionText(" help you move around.")
            }

            HStack(spacing: 0) {
                HighlightedDescriptionText("ENTER")
                DescriptionText(" pastes selected clip.")

            }
            HStack(spacing: 0) {
                HighlightedDescriptionText("BACKSPACE")
                DescriptionText(" deletes clips from history.")
            }

            HStack(spacing: 0) {
                HighlightedDescriptionText("SPACE")
                DescriptionText(" pins to the top.")
            }

            HStack(spacing: 0) {
                HighlightedDescriptionText("ESCAPE")
                DescriptionText(" disappears ClipNinja.")
            }

            DescriptionText("Numeric keys paste a clip with the assigned number.")
        }
    }
}
