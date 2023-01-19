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
        var result: Int = 0

        var left: Int!
        var operand: String!
        var right: Int!
        while elements.count > 1 {

            // Find the first apperance of the priroty operators
            let operandIndex = elements.firstIndex(where: { "×÷".contains($0) }) ?? 1
            let leftIndex = operandIndex - 1
            let rightIndex = operandIndex + 1

            left = Int(elements[leftIndex])!
            operand = elements[operandIndex]
            right = Int(elements[rightIndex])!

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
            default: return nil
            }

            elements.removeSubrange(leftIndex...rightIndex)
            elements.insert("\(result)", at: leftIndex)
        }
        return result
    }

    func empty() {
        elements.removeAll()
    }
}
