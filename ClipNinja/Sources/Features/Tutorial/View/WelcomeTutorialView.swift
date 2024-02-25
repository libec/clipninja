import SwiftUI

// TODO: - Move texts to Strings.swift
struct WelcomeTutorialView: View {
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
            Image(systemName: "figure.wave")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(Colors.prominent)
            TitleText("YO!")
        }
        .padding(.top, 15)
    }

    private var tutorial: some View {
        VStack(spacing: 25) {
            HStack(spacing: 0) {
                DescriptionText("Your clipboard history appears here.")
            }
            HStack(spacing: 0) {
                DescriptionText("Use ")
                HighlightedAlternatingText("ARROWS", alternativeTitle: "↑ ↓ ← →")
                DescriptionText(" to move around, ")
                HighlightedDescriptionText("ENTER")
                DescriptionText(" to paste.")
            }
            HStack(spacing: 0) {
                HighlightedDescriptionText("CMD + SHIFT + V")
                DescriptionText(" summons ClipNinja!")
            }
        }
    }
}

struct WelcomeTutorialView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeTutorialView()
            .frame(width: 500, height: 370)
    }
}
