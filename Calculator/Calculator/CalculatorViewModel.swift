//
//  CalculatorViewModel.swift
//  Calculator
//
//  Created by Yip Ling Shan on 28/10/2023.
//

import Foundation
import SwiftUI

func add(op1: Double, op2: Double) -> Double {
    return op1+op2
}

class CalculatorViewModel: ObservableObject {
    
    @Published var value = "0"
    private var isUserEnteringNumber = false
    private var pendingBinaryOperation: PendingBinaryOperation?
    private var pendingFirstBinaryOperation:PendingBinaryOperation?
    private var pendingSecondBinaryOperation:PendingBinaryOperation?
    private var firstOpeartion: String?
    
    private var accumulator: Double{
        set {
            if newValue == 0{
                self.value = "0"
            }else{
                self.value = "\(newValue)"
            }
        }
        get{
            return Double(value) ?? 0
        }
    }
    private var operations: Dictionary<String, Operation> = [
        CalcuButton.pi.rawValue: Operation.constant(Double.pi),
        CalcuButton.e.rawValue: Operation.constant(M_E),
        CalcuButton.add.rawValue: Operation.binaryOperation(add),
        CalcuButton.equal.rawValue: Operation.equals,
        CalcuButton.subtract.rawValue: Operation.binaryOperation({$0-$1}),
        CalcuButton.multiply.rawValue: Operation.binaryOperation({$0*$1}),
        CalcuButton.divide.rawValue: Operation.binaryOperation({$0/$1}),
        CalcuButton.negative.rawValue: Operation.oneOperation({-$0}),
        CalcuButton.sin.rawValue: Operation.oneOperation({sin(($0*Double.pi)/180)}),
        CalcuButton.cos.rawValue: Operation.oneOperation({cos(($0*Double.pi)/180)}),
        CalcuButton.tan.rawValue: Operation.oneOperation({tan(($0*Double.pi)/180)}),
        CalcuButton.percent.rawValue: Operation.oneOperation({$0/100}),
        CalcuButton.square.rawValue: Operation.oneOperation({$0*$0}),
        CalcuButton.clear.rawValue: Operation.clear
    ]
    
    private enum Operation{
        case constant(Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
        case clear
        case oneOperation((Double) -> Double)
    }
    
    let buttons: [[CalcuButton]] = [
        [.e, .square],
        [.pi, .tan, .sin, .cos],
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two,.three, .add],
        [.zero, .decimal, .equal]
    ]
    let buttons2: [[CalcuButton]] = [
        [.e, .square],
        [.seven, .eight, .nine, .divide, .tan, .clear],
        [.four, .five, .six, .multiply, .cos, .pi],
        [.one, .two,.three, .subtract, .sin, .negative],
        [.zero, .decimal, .add, .percent, .equal]
    ]
    
    func didTap(button: CalcuButton) {
        if button.isDigit == true{
            digitPressed(button: button)
        } else {
            operationPressed(button: button)
        }
    }
    func digitPressed(button: CalcuButton){
        let number = button.rawValue
        if value == "0" && button == .decimal{
            value = "0."
        } else if value == "0" || !isUserEnteringNumber{
            value = number
        } else if button == .decimal{
            if !value.contains("."){
                value += number
            }
        }else {
            value += number
            
        }
        isUserEnteringNumber = true
        //self.value = "\(self.value)\(number)"
    }
    func operationPressed(button: CalcuButton){
        
        isUserEnteringNumber = false
        if let operation = operations[button.rawValue]{
            switch operation {
            case .constant(let resultValue):
                accumulator = resultValue
            case .binaryOperation(let function):
                pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator)
            case .equals:
                performPendingBinaryOperation()
            case .clear:
                accumulator = 0
            case .oneOperation(let function):
                accumulator = function(accumulator)
            }
        }
    }
    

    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double)->Double {
            return function(firstOperand, secondOperand)
        }
    }
                            
    private func performPendingBinaryOperation(){
        if pendingBinaryOperation != nil{
            accumulator = pendingBinaryOperation!.perform(with: accumulator)
            pendingBinaryOperation = nil
        }
    }
}
