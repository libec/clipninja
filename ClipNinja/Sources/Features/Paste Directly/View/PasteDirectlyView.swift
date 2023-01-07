import SwiftUI

struct PasteDirectlyView: View {
    
    private let showSettings: () -> Void

    init(showSettings: @escaping () -> Void) {
        self.showSettings = showSettings
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(R.Settings.PasteDirectly.settingLabel)
                .font(.headline)
            Text(R.Settings.PasteDirectly.permissionDescription)
            Text(R.Settings.PasteDirectly.howToAllowPermission)
            Button(R.Settings.PasteDirectly.showSettingsButton) {
                showSettings()
            }
        }
        .padding()
        .background(Colors.backgroundColor)
        .foregroundColor(Colors.defaultTextColor)
    }
}

struct PasteDirectlyView_Previews: PreviewProvider {

    static var previews: some View {
        PasteDirectlyView(showSettings: {})
            .frame(width: 400, height: 250)
    }
}
