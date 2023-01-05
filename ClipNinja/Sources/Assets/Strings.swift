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

            static let permissionDescription = "\(Strings.Generic.wip) This feature requires permissions from the system."
            static let howToAllowPermission = "\(Strings.Generic.wip) You can enable ClipNinja in system preferences > privacy > accessibility."
            static let addPermissionButton = "\(Strings.Generic.wip) Enable directly"
            static let showSettingsButton = "\(Strings.Generic.wip) Show settings"
        }
    }

    enum Clipboard {
        enum EmptyState {

        }
    }

    public enum MenuItems {
        
    }
}
