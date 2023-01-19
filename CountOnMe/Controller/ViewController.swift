//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!

    var calc: SimpleCalc!

    var expressionHaveResult: Bool {
        return textView.text.firstIndex(of: "=") != nil
    }

    var errorOccured: Bool {
        return textView.text == "Error"
    }

    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        calc = SimpleCalc()
    }

    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else { return }

        if expressionHaveResult || errorOccured {
            calc.empty()
        }

        calc.addNumber(numberText)
        refreshTextView()
    }

    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        guard !errorOccured else { return }

        if calc.canAddOperator {
            calc.addOperator("+")
            refreshTextView()
        } else {
            let alertVC = UIAlertController(title: "Zéro!",
                                            message: "Un operateur est déja mis !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }

    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        guard !errorOccured else { return }

        if calc.canAddOperator {
            calc.addOperator("-")
            refreshTextView()
        } else {
            let alertVC = UIAlertController(title: "Zéro!",
                                            message: "Un operateur est déja mis !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }

    @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
        guard !errorOccured else { return }

        if calc.canAddOperator {
            calc.addOperator("×")
            refreshTextView()
        } else {
            let alertVC = UIAlertController(title: "Zéro!",
                                            message: "Un operateur est déja mis !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }

    @IBAction func tappedDivisionButton(_ sender: UIButton) {
        guard !errorOccured else { return }

        if calc.canAddOperator {
            calc.addOperator("÷")
            refreshTextView()
        } else {
            let alertVC = UIAlertController(title: "Zéro!",
                                            message: "Un operateur est déja mis !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        guard calc.expressionIsCorrect && !errorOccured else {
            let alertVC = UIAlertController(title: "Zéro!",
                                            message: "Entrez une expression correcte !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }

        guard calc.expressionHaveEnoughElement else {
            let alertVC = UIAlertController(title: "Zéro!",
                                            message: "Démarrez un nouveau calcul !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }

        // Check if no error occured to show the result
        if let result = calc.compute() {
            textView.text.append(" = \(result)")
        } else {
            textView.text = "Error"
        }

    }

    func refreshTextView() {
        textView.text = calc.expression
    }

    @IBAction func tappedResetButton(_ sender: UIButton) {
        textView.text = ""
        calc.empty()
    }
}
