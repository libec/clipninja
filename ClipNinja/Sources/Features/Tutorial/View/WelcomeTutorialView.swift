import SwiftUI

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
            titleText("YO!")
        }
        .padding(.top, 15)
    }

    private var tutorial: some View {
        VStack(alignment: .center, spacing: 25) {
            HStack(spacing: 0) {
                descriptionText("Your clipboard history appears here.")
            }
            HStack(spacing: 0) {
                descriptionText("Use ")
                descriptionSelectedText("ARROWS")
                descriptionText(" to move around, ")
                descriptionSelectedText("ENTER")
                descriptionText(" to paste.")
            }
            HStack(spacing: 0) {
                descriptionSelectedText("CMD + SHIFT + V")
                descriptionText(" summons ClipNinja!")
                Image("AppIcon")
            }
        }
    }

    private func titleText(_ text: String) -> some View {
        Text(text)
            .font(.avenir(size: 22))
            .fontWeight(.bold)
            .foregroundColor(Colors.defaultTextColor)
    }

    private func descriptionSelectedText(_ text: String) -> some View {
        styledDescriptionText(text)
            .padding(6)
            .background(Colors.prominent)
            .cornerRadius(4, antialiased: true)
            .foregroundColor(Colors.selectedTextColor)
            .font(.courier(size: 20))
    }

    private func descriptionText(_ text: String) -> some View {
        styledDescriptionText(text)
            .foregroundColor(Colors.defaultTextColor)
            .font(.avenir(size: 18))
    }

    private func styledDescriptionText(_ text: String) -> some View {
        Text(text)
            .fontWeight(.bold)
    }
}

struct WelcomeTutorialView_Previews: PreviewProvider {

    static var previews: some View {
        WelcomeTutorialView()
            .frame(width: 500, height: 370)
    }
}

