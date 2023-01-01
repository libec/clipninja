public typealias R = Strings

public enum Strings {

    public enum Generic {
        public static let wip = "🚧🚧🚧"
        public static let appName = "ClipNinja"
    }

    public enum Settings {
        static let launchAtLogin = "Launch at login"
        public static let openAppShortcut = "Shortcut"
        public static let wip = Strings.Generic.wip

        public enum PasteDirectly {
            static let settingLabel = "Paste Directly"
            static let featureDescription = "\(Strings.Generic.appName) pastes selected clip directly to the underlying app."
            static let permissionDescription = "In order to paste directly, you need to allow"
            static let accessibilityUrl = "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
        }
    }

    enum Clipboard {
        enum EmptyState {

        }
    }

    public enum MenuItems {
        
    }
}
