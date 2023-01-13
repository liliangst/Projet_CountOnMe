//
//  Calculus.swift
//  CountOnMe
//
//  Created by Lilian Grasset on 10/01/2023.
//

import Foundation

class SimpleCalc {

    static var maxInt = 999_999_999
    static var minInt = -maxInt

    var operationElements: [String]!

    // Compute the operation et return the result
    func compute() -> Int? {

        let left = Int(operationElements[0])!
        let operand = operationElements[1]
        let right = Int(operationElements[2])!

        let result: Int
        switch operand {
        case "+":
            if left < Int.max - right {
                result = left + right
            } else {
                return nil
            }
        case "-":
            if left > Int.min + right {
                result = left - right
            } else {
                return nil
            }
        case "×":
            if right == 0 || left < Int.max / right {
                result = left * right
            } else {
                return nil
            }
        case "÷":
            if right != 0 {
                result = left / right
            } else {
                return nil
            }
        default: fatalError("Unknown operator !")
        }

        return result
    }
}
