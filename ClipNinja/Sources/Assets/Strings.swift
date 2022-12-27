public typealias R = Strings

public enum Strings {

    public enum Generic {
        public static let wip = "🚧🚧🚧"
    }

    public enum Settings {
        static let accessibilityUrl = "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
        static let pasteDirectly = "Paste Directly"
        static let openAccessibilitySettings = "Open Accesibility Settings"
        static let launchAtLogin = "Launch at login"
        static let accessibilityPermission = "App has permission to paste directly"
        public static let openAppShortcut = "Open ClipNinja Shortcut"
        public static let wip = Strings.Generic.wip
    }

    enum Clipboard {
        enum EmptyState {

        }
    }

    public enum MenuItems {
        
    }
}
