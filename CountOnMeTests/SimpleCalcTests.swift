//
//  SimpleCalcTests.swift
//  SimpleCalcTests
//
//  Created by Lilian Grasset on 10/01/2023.
//  Copyright © 2023 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class SimpleCalcTests: XCTestCase {
    var calc: SimpleCalc!

    override func setUp() {
        super.setUp()

        calc = SimpleCalc()
    }

    func setElements(from expression: String) {
        calc.elements = expression.split(separator: " ").map { "\($0)" }
    }

    func testGiven1plus1_WhenComputingIt_ThenResultIsEqualTo2() {
        let expression = "1 + 1"
        setElements(from: expression)

        let result = calc.compute()

        XCTAssertEqual(result, 2)
    }

    func testGiven1minus1_WhenComputingIt_ThenResultIsEqualTo0() {
        let expression = "1 - 1"
        setElements(from: expression)

        let result = calc.compute()

        XCTAssertEqual(result, 0)
    }

    func testGiven1times2_WhenComputingIt_ThenResultIsEqualTo2() {
        let expression = "1 × 2"
        setElements(from: expression)

        let result = calc.compute()

        XCTAssertEqual(result, 2)
    }

    func testGiven4dividedBy2_WhenComputingIt_ThenResultIsEqualTo2() {
        let expression = "4 ÷ 2"
        setElements(from: expression)

        let result = calc.compute()

        XCTAssertEqual(result, 2)
    }

    func testGiven1dividedBy0_WhenComputingIt_ThenResultIsNil() {
        let expression = "1 ÷ 0"
        setElements(from: expression)

        let result = calc.compute()

        XCTAssertNil(result)
    }

    func testGivenUnknownOperand_WhenComputingIt_ThenResultIsNil() {
        let expression = "2 ^ 2"
        setElements(from: expression)

        let result = calc.compute()

        XCTAssertNil(result)
    }

    func testGivenEmptyExpression_WhenAddingElements_ThenElementsContainsExpression() {
        calc.addNumber("1")
        calc.addOperator("+")
        calc.addNumber("1")

        let elements = calc.elements

        XCTAssertEqual(elements, ["1", "+", "1"])
    }

    func testGivenEmptyExpression_WhenAddingNumber1TwoTimes_ThenFirstElementsShouldBe11() {
        calc.addNumber("1")
        calc.addNumber("1")

        let firstElements = calc.elements.first

        XCTAssertNotNil(firstElements)
        XCTAssertEqual(firstElements, "11")
    }

    func testGivenElements_WhenAccessingExpression_ThenReturnExpressionInSingleString() {
        calc.addNumber("1")
        calc.addOperator("+")
        calc.addNumber("1")

        let expression = calc.expression

        XCTAssertEqual(expression, "1 + 1")
    }

    func testGivenIncorrectExpression_WhenCheckingIfExpressionIsCorrect_ThenShouldBeFalse() {
        calc.addNumber("1")
        calc.addOperator("+")

        XCTAssertFalse(calc.expressionIsCorrect)
    }

    func testGivenIncorrectExpression_WhenCheckingIfExpressionHaveEnoughElements_ThenShouldBeFalse() {
        calc.addNumber("1")
        calc.addOperator("+")

        XCTAssertFalse(calc.expressionHaveEnoughElement)
    }

    func testGivenExpressionEndedWithNumber_WhenCkeckingIfCanAddOperator_ThenShouldBeTrue() {
        calc.addNumber("1")

        XCTAssertTrue(calc.canAddOperator)
    }

    func testGiven1plus1plus1_WhenComputingIt_ThenResultShouldBe3() {
        let expression = "1 + 1 + 1"
        setElements(from: expression)

        let result = calc.compute()

        XCTAssertNotNil(result)
        XCTAssertEqual(result, 3)
    }

    func testGiven1plus1times2_WhenComputingIt_ThenResultShouldBe3() {
        let expression = "1 + 1 × 2"
        setElements(from: expression)

        let result = calc.compute()

        XCTAssertNotNil(result)
        XCTAssertEqual(result, 3)
    }

    func testGivenExpressionInElements_WhenEmpyingIt_ThenElementsIsEmpty() {
        let expression = "1 + 1"
        setElements(from: expression)

        calc.empty()

        XCTAssertEqual(calc.elements.count, 0)
    }

    func testGivenNumberWith6Decimals_WhenFormatingItTo5_ThenStringNumberHas5DecimalsAndIsRounded() {
        let number: Double = 1.234567

        let formatedNumber = calc.format(number)

        XCTAssertEqual(formatedNumber, "1.23457")
    }

    func testGivenDoubleHas0AsDecimal_WhenFormatingIt_ThenStringNumberShouldNotHave0AsDecimal() {
        let number: Double = 1.0

        let formatedNumber = calc.format(number)

        XCTAssertEqual(formatedNumber, "1")
    }
}
