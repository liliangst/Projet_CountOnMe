//
//  CalculationEngineTests.swift
//  CalculationEngineTests
//
//  Created by Lilian Grasset on 10/01/2023.
//  Copyright © 2023 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CalculationEngineTests: XCTestCase {
    var calc: CalculationEngine!
    var dummyViewController: DummyViewController!

    override func setUp() {
        super.setUp()

        calc = CalculationEngine()
        dummyViewController = DummyViewController()
        calc.delegate = dummyViewController
    }

    func getResultFromCurrentExpression() -> String {
        let elements = dummyViewController.text.split(separator: " ").map { "\($0)" }
        guard let result = elements.last else {
            return "error"
        }
        return result
    }

    func testGiven1plus1_WhenComputingIt_ThenExpressionIsCorrect() throws {
        calc.tappedNumberButton("1")
        calc.tappedOperatorButton("+")
        calc.tappedNumberButton("1")

        calc.tappedEqualButton()
        let expression = dummyViewController.text

        XCTAssertEqual(expression, "1 + 1 = 2")
    }

    func testGiven1minus1_WhenComputingIt_ThenResultIsEqualTo0() {
        calc.tappedNumberButton("1")
        calc.tappedOperatorButton("-")
        calc.tappedNumberButton("1")

        calc.tappedEqualButton()
        let result = getResultFromCurrentExpression()

        XCTAssertEqual(result, "0")
    }

    func testGiven1times2_WhenComputingIt_ThenResultIsEqualTo2() {
        calc.tappedNumberButton("1")
        calc.tappedOperatorButton("×")
        calc.tappedNumberButton("2")

        calc.tappedEqualButton()
        let result = getResultFromCurrentExpression()

        XCTAssertEqual(result, "2")
    }

    func testGiven4dividedBy2_WhenComputingIt_ThenResultIsEqualTo2() {
        calc.tappedNumberButton("4")
        calc.tappedOperatorButton("÷")
        calc.tappedNumberButton("2")

        calc.tappedEqualButton()
        let result = getResultFromCurrentExpression()

        XCTAssertEqual(result, "2")
    }

    func testGiven1dividedBy0_WhenComputingIt_ThenErrorIsThrown() {
        calc.tappedNumberButton("1")
        calc.tappedOperatorButton("÷")
        calc.tappedNumberButton("0")

        calc.tappedEqualButton()
        let errorText = dummyViewController.text

        XCTAssertEqual(errorText, "Error")
    }

    func testGivenUnknownOperand_WhenComputingIt_ThenErrorIsThrown() {
        calc.tappedNumberButton("2")
        calc.tappedOperatorButton("^")
        calc.tappedNumberButton("2")

        calc.tappedEqualButton()
        let errorText = dummyViewController.text

        XCTAssertEqual(errorText, "Error")
    }

    func testGivenEmptyExpression_WhenAddingElements_ThenElementsContainsExpression() {
        calc.tappedNumberButton("1")
        calc.tappedOperatorButton("+")
        calc.tappedNumberButton("1")

        let expression = dummyViewController.text

        XCTAssertEqual(expression, "1 + 1")
    }

    func testGivenEmptyExpression_WhenAddingNumber1TwoTimes_ThenFirstElementsShouldBe11() {
        calc.tappedNumberButton("1")
        calc.tappedNumberButton("1")

        let expression = dummyViewController.text

        XCTAssertEqual(expression, "11")
    }

    func testGivenIncorrectExpression_WhenTappingEqual_ThenShouldGetAnAlert() {
        calc.tappedNumberButton("1")
        calc.tappedOperatorButton("+")

        calc.tappedEqualButton()
        let alertText = dummyViewController.alertText

        XCTAssertEqual(alertText, "Entrez une expression correcte !")
    }

    func testGivenNotEnoughElements_WhenTappingEqual_ThenShouldGetAnAlert() {
        // 0 elements

        calc.tappedEqualButton()
        let alertText = dummyViewController.alertText

        XCTAssertEqual(alertText, "Démarrez un nouveau calcul !")
    }

    func testGiven1plus1plus1_WhenTappingEqual_ThenResultShouldBe3() {
        calc.tappedNumberButton("1")
        calc.tappedOperatorButton("+")
        calc.tappedNumberButton("1")
        calc.tappedOperatorButton("+")
        calc.tappedNumberButton("1")

        calc.tappedEqualButton()
        let result = getResultFromCurrentExpression()

        XCTAssertEqual(result, "3")
    }

    func testGiven1plus1times2_WhenTappingEqual_ThenResultShouldBe3() {
        calc.tappedNumberButton("1")
        calc.tappedOperatorButton("+")
        calc.tappedNumberButton("1")
        calc.tappedOperatorButton("×")
        calc.tappedNumberButton("2")

        calc.tappedEqualButton()
        let result = getResultFromCurrentExpression()

        XCTAssertEqual(result, "3")
    }

    func testGiven4dividedBy2times2_WhenTappingEqual_ThenResultShouldBe4() {
        calc.tappedNumberButton("4")
        calc.tappedOperatorButton("÷")
        calc.tappedNumberButton("2")
        calc.tappedOperatorButton("×")
        calc.tappedNumberButton("2")

        calc.tappedEqualButton()
        let result = getResultFromCurrentExpression()

        XCTAssertEqual(result, "4")
    }

    func testGivenExpressionInElements_WhenTappingAC_ThenExpressionIsEmpty() {
        calc.tappedNumberButton("1")
        calc.tappedOperatorButton("+")
        calc.tappedNumberButton("1")

        calc.tappedResetButton()
        let expression = dummyViewController.text

        XCTAssertEqual(expression, "")
    }

    func testGiven10dividedBy3_WhenTappingEqual_ThenResultHas5digits() {
        calc.tappedNumberButton("10")
        calc.tappedOperatorButton("÷")
        calc.tappedNumberButton("3")

        calc.tappedEqualButton()
        let result = getResultFromCurrentExpression()

        XCTAssertEqual(result, "3.33333")
    }

    func testGiven1e12times1e12_WhenTappingEqual_ThenResultShouldBe1e24() {
        calc.tappedNumberButton("1000000000000")
        calc.tappedOperatorButton("×")
        calc.tappedNumberButton("1000000000000")

        calc.tappedEqualButton()
        let result = getResultFromCurrentExpression()

        XCTAssertEqual(result, "1000000000000000000000000")
    }

    func testGivenExpressionWithResult_WhenTappingANumber_ThenExpressionIsOnlyThisNumber() {
        calc.tappedNumberButton("1")
        calc.tappedOperatorButton("+")
        calc.tappedNumberButton("1")
        calc.tappedEqualButton()

        calc.tappedNumberButton("2")
        let expression = dummyViewController.text

        XCTAssertEqual(expression, "2")
    }

    func testGivenExpressionEndingWithOperator_WhenAddingAnOperator_ThenShouldGetAnAlert() {
        calc.tappedNumberButton("1")
        calc.tappedOperatorButton("+")

        calc.tappedOperatorButton("-")
        let alertText = dummyViewController.alertText

        XCTAssertEqual(alertText, "Un operateur est déja mis !")
    }

    func testGivenErrorMessage_WhenTappingAnOperator_ThenTextShouldStayAsError() {
        calc.tappedNumberButton("1")
        calc.tappedOperatorButton("÷")
        calc.tappedNumberButton("0")
        calc.tappedEqualButton()

        calc.tappedOperatorButton("+")
        let text = dummyViewController.text

        XCTAssertEqual(text, "Error")
    }

    func testGivenErrorMessage_WhenTappingANumber_ThenTextShouldStayAsError() {
        calc.tappedNumberButton("1")
        calc.tappedOperatorButton("÷")
        calc.tappedNumberButton("0")
        calc.tappedEqualButton()

        calc.tappedNumberButton("1")
        let text = dummyViewController.text

        XCTAssertEqual(text, "1")
    }

    func testGivenEmptyExpression_WhenTappingAnOperator_ThenShouldGetAnAlert() {
        // Expression is empty

        calc.tappedOperatorButton("+")
        let alertText = dummyViewController.alertText

        XCTAssertEqual(alertText, "Commencez par ajouter un nombre !")
    }
}

class DummyViewController: CalculationDelegate {
    var text: String!
    var alertText: String!

    func displayAlert(_ text: String) {
        alertText = text
    }

    func updateCalculText(_ text: String) {
        self.text = text
    }
}
