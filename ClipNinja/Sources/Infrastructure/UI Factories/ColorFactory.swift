import AppKit
import SwiftUI

public enum Colors {

    private static var darkModeColorFactory = DarkModeColorFactory()
    private static var lightModeColorFactory = LightModeColorFactory()

    public static var factory: ColorFactory {
        if shouldUseDarkMode() {
            return darkModeColorFactory
        } else {
            return lightModeColorFactory
        }
    }

    static func shouldUseDarkMode() -> Bool {
        return true
//        if #available(OSX 10.14, *) {
//            return NSApp.effectiveAppearance.name == .darkAqua
//        } else {
//            return false
//        }
    }

    fileprivate static let pastelBlue = Color(red: 181/255, green: 225/255, blue: 253/255)
    fileprivate static let pastelYellow = Color(red: 255/255, green: 255/255, blue: 191/255)
    fileprivate static let pastelRed = Color(red: 220/255, green: 76/255, blue: 94/255)
    fileprivate static let darkPastelRed = Color(red: 202/255, green: 58/255, blue: 43/255)
    fileprivate static let pastelGreen = Color(red: 223/255, green: 255/255, blue: 237/255)
}

class DarkModeColorFactory: ColorFactory {
    let clear = Color.clear
    let prominent = Colors.pastelRed
    let defaultTextColor = Color(red: 133/255, green: 139/255, blue: 152/255, opacity: 1.0)
    let selectedTextColor = Color(red: 0.8, green: 0.8, blue: 0.8, opacity: 1.0)
    let backgroundColor = Color(red: 38/255, green: 41/255, blue: 44/255, opacity: 1)
    let selectedBackgroundColor = Color(red: 235/255, green: 235/255, blue: 235/255, opacity: 0.2)
}

class LightModeColorFactory: ColorFactory {
    let clear = Color.clear
    let prominent = Colors.darkPastelRed
    let defaultTextColor = Color(red: 13/255, green: 13/255, blue: 15/255, opacity: 1.0)
    let selectedTextColor = Color(red: 230/255, green: 230/255, blue: 230/255, opacity: 1.0)
    let backgroundColor = Color(red: 38/255, green: 41/255, blue: 44/255, opacity: 1)
    let selectedBackgroundColor = Color(red: 38/255, green: 41/255, blue: 44/255, opacity: 0.7)
}

public protocol ColorFactory {
    var clear: Color { get }
    var prominent: Color { get }
    var defaultTextColor: Color { get }
    var selectedTextColor: Color { get }
    var backgroundColor: Color { get }
    var selectedBackgroundColor: Color { get }
}
