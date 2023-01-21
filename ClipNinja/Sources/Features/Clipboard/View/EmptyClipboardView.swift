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
            TitleText("You have empty clipboard history!")
                .font(.courier(size: 25))
            Text("（╯°□°）╯︵ ┻━┻ ")
                .font(.avenir(size: 35))
                .foregroundColor(Colors.prominent)
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
        VStack(spacing: 25) {
            HStack(spacing: 0) {
                HighlightedDescriptionText("Copy")
                DescriptionText(" stuff,")
                HighlightedDescriptionText("see")
                DescriptionText(" that stuff here.")
            }
            HStack {
                HighlightedDescriptionText("Paste")
                DescriptionText("it, and")
                HighlightedDescriptionText("go")
                DescriptionText("do your thing!")
            }
        }
    }

    private var whatToDoImages: some View {
        HStack(spacing: 20) {
            HighlightedImage(systemName: "scissors")
            HighlightedImage(systemName: "eyes")
            HighlightedImage(systemName: "return")
            HighlightedImage(systemName: "figure.walk")
        }
        .padding(20)
        .background(Colors.prominent)
        .cornerRadius(6, antialiased: true)
        .frame(maxHeight: 80)
        .padding(.bottom, 50)
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
