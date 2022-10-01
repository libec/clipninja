enum LegacyClipNinjaKeyboardHandling {
    enum KeyPress {
        case key(Key)
        case numeric(NumericKey)
    }

    enum Key: UInt16 {
        case down = 125
        case up = 126
        case left = 123
        case right = 124
        case esc = 53
        case enter = 36
        case space = 49
        case backspace = 51
        case w = 13
    }

    enum NumericKey: UInt16 {

        //    case num0 = 29
        case num1 = 18
        case num2 = 19
        case num3 = 20
        case num4 = 21
        case num5 = 23
        case num6 = 22
        case num7 = 26
        case num8 = 28
        case num9 = 25

        //    case right0 = 82
        case right1 = 83
        case right2 = 84
        case right3 = 85
        case right4 = 86
        case right5 = 87
        case right6 = 88
        case right7 = 89
        case right8 = 91
        case right9 = 92

        func mapToIndex() -> Int {
            switch self {
            case .num1, .right1: return 0
            case .num2, .right2: return 1
            case .num3, .right3: return 2
            case .num4, .right4: return 3
            case .num5, .right5: return 4
            case .num6, .right6: return 5
            case .num7, .right7: return 6
            case .num8, .right8: return 7
            case .num9, .right9: return 8
            }
        }
    }

}
