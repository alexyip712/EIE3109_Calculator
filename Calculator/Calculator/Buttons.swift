//
//  Buttons.swift
//  Calculator
//
//  Created by Yip Ling Shan on 28/10/2023.
//

//import Foundation
import SwiftUI

enum CalcuButton: String{
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case add = "+"
    case subtract = "-"
    case multiply = "x"
    case divide = "/"
    case equal = "="
    case clear = "AC"
    case decimal = "."
    case percent = "%"
    case negative = "+/-"
    case sin = "sin"
    case cos = "cos"
    case pi = "π"
    case e = "e"
    case square = "^2"
    case tan = "tan"
    var buttonColor: Color {
        switch self{
        case .negative, .percent, .add, .subtract, .multiply, .divide, .equal:
            return .orange
        case .sin, .cos, .pi, .e, .tan, .square:
            return Color(.lightGray)
        case .clear:
            return .red
        default:
            return Color(UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1))
        }
    }
    var isDigit: Bool{
        switch self{
        case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero, .decimal:
            return true
        default:
            return false
        }
    }
}
