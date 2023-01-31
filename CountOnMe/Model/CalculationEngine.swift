//
//  CalculationEngine.swift
//  CountOnMe
//
//  Created by Lilian Grasset on 10/01/2023.
//

import Foundation

protocol CalculationDelegate: AnyObject {
    func updateCalculText(_ text: String)
    func displayAlert(_ text: String)
}

enum CalculationError: Error {
    case divisionBy0
    case unknownOperator
}

class CalculationEngine {

    weak var delegate: CalculationDelegate?

    private var elements: [String] = [String]()

    private var maxFormattingDigits = 5

    // Get the expression as a single string
    private var expression: String {
        elements.joined(separator: " ")
    }

    // MARK: Error check computed variables
    private var expressionEndWithOperator: Bool {
        elements.last == "+" || elements.last == "-" || elements.last == "×" || elements.last == "÷"
    }

    private var expressionIsCorrect: Bool {
        !expressionEndWithOperator
    }

    private var expressionHaveEnoughElement: Bool {
        elements.count >= 3
    }

    private var canAddOperator: Bool {
        !expressionEndWithOperator && ((elements.last?.allSatisfy({ $0.isNumber })) != nil)
    }

    private var canAddNumber: Bool {
        (elements.last?.allSatisfy({ $0.isNumber })) ?? false
    }

    private var errorHasOccured: Bool = false

    private var expressionHaveResult: Bool = false

    private func addOperator(_ operatorString: String) {
        elements.append(operatorString)
    }

    // Add a digit to the current number or add a new number to elements
    private func addNumber(_ numberString: String) {
        if canAddNumber, let lastIndex = elements.indices.last {
            elements[lastIndex] = elements[lastIndex] + numberString
        } else {
            elements.append(numberString)
            return
        }
    }

    // Compute the operation et return the result or nil if an error occured
    private func compute() throws -> Double {
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
            case "-":
                result = left - right
            case "×":
                result = left * right
            case "÷":
                if right != 0 {
                    result = left / right
                } else {
                    throw CalculationError.divisionBy0
                }
            default: throw CalculationError.unknownOperator
            }

            // Remove the current operation
            elements.removeSubrange(leftIndex...rightIndex)

            // Insert the result of the operation in the expression
            elements.insert(format(result), at: leftIndex)
        }
        return result
    }

    // Formating a number so it has less decimals
    private func format(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = maxFormattingDigits
        formatter.decimalSeparator = "."
        let formatedValue = formatter.string(from: number as NSNumber)

        return formatedValue!
    }

    private func clear() {
        elements.removeAll()
        expressionHaveResult = false
        errorHasOccured = false
    }
}

// Tapped button functions
extension CalculationEngine {
    func tappedNumberButton(_ numberText: String) {
        if expressionHaveResult || errorHasOccured {
            clear()
        }

        addNumber(numberText)
        delegate?.updateCalculText(expression)
    }

    func tappedOperatorButton(_ operand: String) {
        guard !errorHasOccured else { return }

        guard !canAddOperator else {
            addOperator(operand)
            expressionHaveResult = false
            delegate?.updateCalculText(expression)
            return
        }

        guard expressionEndWithOperator else {
            delegate?.displayAlert("Commencez par ajouter un nombre !")
            return
        }

        delegate?.displayAlert("Un operateur est déja mis !")
    }

    func tappedEqualButton() {
        guard expressionIsCorrect else {
            delegate?.displayAlert("Entrez une expression correcte !")
            return
        }

        guard expressionHaveEnoughElement else {
            delegate?.displayAlert("Démarrez un nouveau calcul !")
            return
        }

        // Check if no error occured to show the result
        do {
            let currentExpression = expression
            let result = try compute()
            delegate?.updateCalculText(currentExpression + " = \(format(result))")
            expressionHaveResult = true
        } catch {
            if error is CalculationError {
                errorHasOccured = true
                delegate?.updateCalculText("Error")
                print("Error is \(error.self)")
            }
        }
    }

    func tappedResetButton() {
        clear()
        delegate?.updateCalculText("")
    }
}
