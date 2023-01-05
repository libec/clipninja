import SwiftUI

struct PasteDirectlyView: View {

    @Environment(\.dismiss) var dismiss

    private let showSettings: () -> Void
    private let addPermissions: () -> Void

    init(showSettings: @escaping () -> Void, addPermissions: @escaping () -> Void) {
        self.showSettings = showSettings
        self.addPermissions = addPermissions
    }

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
                    showSettings()
                }
                
                Button(R.Settings.PasteDirectly.addPermissionButton) {
                    addPermissions()
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
        PasteDirectlyView(showSettings: {}, addPermissions: {})
            .frame(width: 400, height: 250)
    }
}
