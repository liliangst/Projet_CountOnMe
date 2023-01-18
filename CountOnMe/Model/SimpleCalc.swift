//
//  Calculus.swift
//  CountOnMe
//
//  Created by Lilian Grasset on 10/01/2023.
//

import Foundation

class SimpleCalc {

    var elements: [String] = [String]()

    // Get the expression as a single string
    var expression: String {
        elements.joined(separator: " ")
    }

    func addOperator(_ operatorString: String) {
        elements.append(operatorString)
    }

    func addNumber(_ numberString: String) {
        if !expressionEndWithOperator, let lastIndex = elements.indices.last {
            elements[lastIndex] = elements[lastIndex] + numberString
        } else {
            elements.append(numberString)
            return
        }
    }

    // Error check computed variables
    private var expressionEndWithOperator: Bool {
        elements.last == "+" || elements.last == "-" || elements.last == "×" || elements.last == "÷"
    }

    var expressionIsCorrect: Bool {
        !expressionEndWithOperator
    }

    var expressionHaveEnoughElement: Bool {
        elements.count >= 3
    }

    var canAddOperator: Bool {
        !expressionEndWithOperator
    }

    // Compute the operation et return the result
    func compute() -> Int? {

        let left = Int(elements[0])!
        let operand = elements[1]
        let right = Int(elements[2])!

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
