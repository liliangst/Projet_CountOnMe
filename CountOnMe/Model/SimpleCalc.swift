//
//  SimpleCalc.swift
//  CountOnMe
//
//  Created by Lilian Grasset on 10/01/2023.
//

import Foundation

class SimpleCalc {

    var elements: [String] = [String]()

    var maxDecimalsFormating = 5

    // Get the expression as a single string
    var expression: String {
        elements.joined(separator: " ")
    }

    func addOperator(_ operatorString: String) {
        elements.append(operatorString)
    }

    // Add a digit to the current number or add a new number to elements
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
        !expressionEndWithOperator && ((elements.last?.allSatisfy({ $0.isNumber })) != nil)
    }

    // Compute the operation et return the result or nil if an error occured
    func compute() -> Double? {
        var result: Double = 0

        var left: Double!
        var operand: String!
        var right: Double!
        while elements.count > 1 {

            // Find the first apperance of the priroty operators
            let operandIndex = elements.firstIndex(where: { "×÷".contains($0) }) ?? 1
            let leftIndex = operandIndex - 1
            let rightIndex = operandIndex + 1

            left = Double(elements[leftIndex])!
            operand = elements[operandIndex]
            right = Double(elements[rightIndex])!

            switch operand {
            case "+":
                result = left + right
                /*if left < Double(Int.max) - right {
                    result = left + right
                } else {
                    return nil
                }*/
            case "-":
                result = left - right
                /*if left > Double(Int.min) + right {
                    result = left - right
                } else {
                    return nil
                }*/
            case "×":
                result = left * right
                /*if right == 0 || left < Double(Int.max) / right {
                    result = left * right
                } else {
                    return nil
                }*/
            case "÷":
                if right != 0 {
                    result = left / right
                } else {
                    return nil
                }
            default: return nil
            }

            // Remove the current operation
            elements.removeSubrange(leftIndex...rightIndex)

            // Insert the result of the operation in the expression
            elements.insert(format(result), at: leftIndex)
        }
        return result
    }

    func empty() {
        elements.removeAll()
    }

    func format(_ number: Double) -> String {
        var formatedValue = String(format: "%.\(maxDecimalsFormating)f", number)

        while formatedValue.last == "0" {
            formatedValue.removeLast()
        }

        if formatedValue.last == "." {
            formatedValue.removeLast()
        }

        return formatedValue
    }

}
