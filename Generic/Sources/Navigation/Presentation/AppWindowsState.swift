import SwiftUI

public class AppWindowsState: ObservableObject {

    public init() { }

    @Published public var mainViewHidden: Bool = false
}
