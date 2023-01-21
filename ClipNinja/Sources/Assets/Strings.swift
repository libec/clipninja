public typealias R = Strings

public enum Strings {

    public enum Generic {
        public static let wip = "🚧🚧🚧"
        public static let appName = "ClipNinja"
    }

    public enum Settings {
        static let launchAtLogin = "Launch at login"
        public static let openAppShortcut = "Shortcut"
        public static let windowName = Generic.appName + " Settings"
        public static let wip = Strings.Generic.wip

        public enum PasteDirectly {
            static let settingLabel = "Paste Directly"
            static let featureDescription = "\(Strings.Generic.appName) pastes selected clip directly to the underlying app."

            public static let accessibilityUrl = "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
            static let permissionDescription = "\(Strings.Generic.wip) The feature requires permissions from the system."
            static let howToAllowPermission = "\(Strings.Generic.wip) You can enable ClipNinja in system preferences > privacy > accessibility."
            static let showSettingsButton = "OPEN SYSTEM SETTINGS"
        }
    }

    enum Clipboard {
        enum EmptyState {

        }
    }

    enum Tutorials {
        static let close = "CLOSE"
        static let showSettings = "OPEN SETTINGS"
    }

    public enum MenuItems {
        public static let clips = "Clips"
        public static let settings = "Settings"
        public static let tutorial = "Tutorial"
        public static let quit = "Quit"
    }
}

