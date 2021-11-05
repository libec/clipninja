import SwiftUI

struct ClipboardRow: View {

    @State private var pinned: Bool
    @State private var selected: Bool
    @State private var text: String
    @State private var shortcut: String

    init(text: String, shortcut: String, pinned: Bool, selected: Bool) {
        self.text = text
        self.shortcut = shortcut
        self.pinned = pinned
        self.selected = selected
    }

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            HStack {
                Spacer()
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        Color .red
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.4, alignment: .center)
                            .clipShape(Capsule())
                        Spacer()
                    }
                }
            }.frame(width: 15)
            Text(text)
                .font(.custom("SF Mono", fixedSize: 14))
                .fontWeight(.semibold)
            Spacer()
            Text(shortcut)
                .font(.custom("Courier New", fixedSize: 25))
                .fontWeight(.bold)
                .foregroundColor(.red)
            Spacer()
                .frame(width: 1)
        }
        .background(selected ? Color.gray : Color.black)
    }
}

struct ClipboardRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
        ClipboardRow(text: "Lorem Ipsum", shortcut: "1", pinned: true, selected: false)
            .frame(width: 400, height: 50)
        ClipboardRow(text: "Dolor sit", shortcut: "↵", pinned: true, selected: true)
            .frame(width: 400, height: 50)
        ClipboardRow(text: "Ames tres", shortcut: "3", pinned: false, selected: false)
            .frame(width: 400, height: 50)
        }
    }
}
