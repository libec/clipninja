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
        if #available(OSX 10.14, *) {
            return NSApp.effectiveAppearance.name == .darkAqua
        } else {
            return false
        }
    }

    fileprivate static let pastelBlue = Color(r: 181, g: 225, b: 253)
    fileprivate static let pastelYellow = Color(r: 255, g: 255, b: 191)
    fileprivate static let pastelRed = Color(r: 220, g: 76, b: 94)
    fileprivate static let darkPastelRed = Color(r: 202, g: 58, b: 43)
    fileprivate static let pastelGreen = Color(r: 223, g: 255, b: 237)
}

class DarkModeColorFactory: ColorFactory {
    let clear = Color.clear
    let prominent = Colors.pastelRed
    let defaultTextColor = Color(r: 133, g: 139, b: 152)
    let selectedTextColor = Color(r: 204, g: 204, b: 204)
    let backgroundColor = Color(r: 38, g: 41, b: 44)
    let selectedBackgroundColor = Color(r: 77, g: 80, b: 82)
}

class LightModeColorFactory: ColorFactory {
    let clear = Color.clear
    let prominent = Colors.darkPastelRed
    let defaultTextColor = Color(r: 29, g: 29, b: 32)
    let selectedTextColor = Color(r: 235, g: 235, b: 235)
    let backgroundColor = Color(r: 227, g: 226, b: 226)
    let selectedBackgroundColor = Color(r: 103, g: 105, b: 107)
}

fileprivate extension Color {
    init(r: Double, g: Double, b: Double) {
        self.init(red: r / 255, green: g / 255, blue: b / 255)
    }
}

public protocol ColorFactory {
    var clear: Color { get }
    var prominent: Color { get }
    var defaultTextColor: Color { get }
    var selectedTextColor: Color { get }
    var backgroundColor: Color { get }
    var selectedBackgroundColor: Color { get }
}
