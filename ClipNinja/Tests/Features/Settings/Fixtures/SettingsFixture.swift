@testable import ClipNinjaPackage

extension Settings {
    static func fixture(
        pasteDirectly: Bool = true,
        launchAtLogin: Bool = true,
        movePastedClipToTop: Bool = true
    ) -> Settings {
        Settings(
            pasteDirectly: pasteDirectly,
            launchAtLogin: launchAtLogin,
            movePastedClipToTop: movePastedClipToTop
        )
    }
}
