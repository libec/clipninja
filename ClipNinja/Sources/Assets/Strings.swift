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

            static let permissionDescription = "\(Strings.Generic.wip) The feature requires permissions from the system."
            static let howToAllowPermission = "\(Strings.Generic.wip) You can enable ClipNinja in system preferences > privacy > accessibility."
            static let showSettingsButton = "\(Strings.Generic.wip) Show settings"
        }
    }

    enum Clipboard {
        enum EmptyState {

        }
    }

    public enum MenuItems {
        public static let clips = "Clips"
        public static let settings = "Settings"
        public static let tutorial = Generic.wip + "Tutorial" + Generic.wip
        public static let quit = "Quit"
    }
}
