import SwiftUI
import InstanceProvider

public struct RootView: View {
    
    private let appStart: AppStart
    
    public init(appStart: AppStart) {
        self.appStart = appStart
    }
    
    public var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                VStack {
                    Text("\(geometry.size.width) x \(geometry.size.height)!")
                    Text("Stuff")
                }
                Spacer()
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height,
                alignment: .leading
            )
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(appStart: AppStart())
    }
}
