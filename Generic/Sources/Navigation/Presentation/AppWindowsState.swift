import SwiftUI
import Combine

public class AppWindowsState: ObservableObject {

    private var subscriptions = Set<AnyCancellable>()
    private let navigation: Navigation

    public init(navigation: Navigation) {
        self.navigation = navigation

        navigation.showClipboard
            .sink { showClipboard in
                self.showClipboard = showClipboard
            }
            .store(in: &subscriptions)
    }

    @Published public var showClipboard: Bool = true
    @Published public var showSettings: Bool = false
}
