import SwiftUI

struct EmptyClipboardView: View {

    var body: some View {
        emptyStateContent
            .background(Colors.backgroundColor)
    }

    var emptyStateContent: some View {
        VStack(spacing: 15) {
            heading
            Spacer()
            whatToDo
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(30)
    }

    private var heading: some View {
        VStack(spacing: 30) {
            HStack {
                // TODO: - Localize this screen, move everything to Strings.swift
                Text("You have empty clipboard history!")
                    .font(.courier(size: 25))
                    .fontWeight(.bold)
                    .foregroundColor(Colors.defaultTextColor)
            }
            HStack {
                Text("（╯°□°）╯︵ ┻━┻ ")
                    .font(.avenir(size: 35))
                    .foregroundColor(Colors.prominent)

            }
        }
        .padding(.top, 50)
    }

    private var whatToDo: some View {
        VStack(alignment: .center, spacing: 30) {
            whatToDoDescription
            whatToDoImages
        }
    }

    private var whatToDoDescription: some View {
        VStack {
            HStack(spacing: 0) {
                descriptionSelectedText("Copy")
                descriptionText(" stuff,")
                descriptionSelectedText("see")
                descriptionText(" that stuff here.")
            }
            HStack {
                descriptionSelectedText("Paste")
                descriptionText("it, and")
                descriptionSelectedText("go")
                descriptionText("do your thing!")
            }
        }
    }

    private var whatToDoImages: some View {
        HStack(spacing: 20) {
            whatToDoImage(systemName: "scissors")
            whatToDoImage(systemName: "eyes")
            whatToDoImage(systemName: "return")
            whatToDoImage(systemName: "figure.walk")
        }
        .padding(20)
        .background(Colors.selectedBackgroundColor)
        .cornerRadius(6, antialiased: true)
        .frame(maxHeight: 80)
        .padding(.bottom, 50)
    }

    private func descriptionSelectedText(_ text: String) -> some View {
        styledDescriptionText(text)
            .padding(6)
            .background(Colors.selectedBackgroundColor)
            .cornerRadius(4, antialiased: true)
            .foregroundColor(Colors.selectedTextColor)
    }


    private func descriptionText(_ text: String) -> some View {
        styledDescriptionText(text)
            .foregroundColor(Colors.defaultTextColor)
    }

    private func styledDescriptionText(_ text: String) -> some View {
        Text(text)
            .font(.courier(size: 20))
            .fontWeight(.bold)
    }

    private func whatToDoImage(systemName: String) -> some View {
        Image(systemName: systemName)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .foregroundColor(Colors.selectedTextColor)
    }
}

struct EmptyClipboardView_Preview: PreviewProvider {
    static var previews: some View {
        EmptyClipboardView()
            .frame(width: 600, height: 580)
            .preferredColorScheme(.light)

        EmptyClipboardView()
            .frame(width: 600, height: 580)
            .preferredColorScheme(.dark)
    }
}
