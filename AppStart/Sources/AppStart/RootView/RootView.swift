import SwiftUI
import InstanceProvider
import Clipboard
import Logger

public struct RootView: View {

    private let appStart: AppStart
    
    public init(appStart: AppStart) {
        self.appStart = appStart
    }
    
    public var body: some View {
        let instanceProvider: InstanceProvider = appStart.startApp()
        let clipboardView = instanceProvider.resolve(ClipboardView.self)
        clipboardView.onAppear {
            log(message: "RootView.onAppear")
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(appStart: AppStart(appSpecificAssemblies: []))
            .frame(width: 400, height: 400)
    }
}
