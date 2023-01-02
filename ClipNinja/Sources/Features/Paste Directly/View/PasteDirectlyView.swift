import SwiftUI

struct PasteDirectlyView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
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
        .padding()
    }
}

struct PasteDirectlyView_Previews: PreviewProvider {

    static var previews: some View {
        PasteDirectlyView()
            .frame(width: 400, height: 250)
    }
}
