//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Yuangang Sheng on 2018/12/22.
//  Copyright © 2018 Johnny. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    //累加器
    private var accumulator: Double?

    
    private enum Operation{
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String, Operation> =
    [
    "π" : Operation.constant(Double.pi),
    "e" : Operation.constant(M_E),
    "√" : Operation.unaryOperation(sqrt),
    "cos" : Operation.unaryOperation(cos),
    "±": Operation.unaryOperation({-$0}),
    "x": Operation.binaryOperation({$0 * $1}),
    "÷": Operation.binaryOperation({$0 / $1}),
    "+": Operation.binaryOperation({$0 + $1}),
    "-": Operation.binaryOperation({$0 - $1}),
    "=": Operation.equals
    ]
    //运算符
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol]{
            switch operation{
            case .constant(let value):
                accumulator = value 
            case .unaryOperation(let function):
                if accumulator != nil{
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil{
                    pbo = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                }
            case .equals:
                performPendingBinaryOperation()
            }
        
        }
        
    }
    
    private mutating func performPendingBinaryOperation(){
        if pbo != nil && accumulator != nil {
            accumulator = pbo!.perform(with: accumulator!)
            pbo = nil
        }
    }
    
    private var pbo:PendingBinaryOperation?
      
    private struct PendingBinaryOperation{
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
        
    }
    //操作数
    //mutating说明这个方法会修改这个struct的变量
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double?{
        get{
           return accumulator
        }
    }
    
}
