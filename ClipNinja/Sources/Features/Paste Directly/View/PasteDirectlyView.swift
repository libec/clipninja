import SwiftUI

struct PasteDirectlyView: View {

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Image(systemName: "xmark")
                .onTapGesture {
                    dismiss()
                }
                .padding(.bottom)

            Text(R.Settings.PasteDirectly.settingLabel)
                .font(.headline)
            Text(R.Settings.PasteDirectly.featureDescription)
            Text(R.Settings.PasteDirectly.howToAllowPermission)
            HStack {
                Button(R.Settings.PasteDirectly.showSettingsButton) {
                    guard let url = URL(string: R.Settings.PasteDirectly.accessibilityUrl) else {
                        log(message: "Failed to create accessibility URL")
                        return
                    }
                    NSWorkspace.shared.open(url)
                }
                
                Button(R.Settings.PasteDirectly.addPermissionButton) {

                }
            }
        }
        .ignoresSafeArea()
        .padding()
        .background(Colors.backgroundColor)
        .foregroundColor(Colors.defaultTextColor)
        .frame(maxWidth: 400, maxHeight: .infinity)
    }
}

struct PasteDirectlyView_Previews: PreviewProvider {

    static var previews: some View {
        PasteDirectlyView()
            .frame(width: 400, height: 250)
    }
}
