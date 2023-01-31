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

    let calc: CalculationEngine = CalculationEngine()

    override func viewDidLoad() {
        super.viewDidLoad()
        calc.delegate = self
    }

    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else { return }
        calc.tappedNumberButton(numberText)
    }

    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        calc.tappedOperatorButton("+")
    }

    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        calc.tappedOperatorButton("-")
    }

    @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
        calc.tappedOperatorButton("×")
//        }
    }

    @IBAction func tappedDivisionButton(_ sender: UIButton) {
        calc.tappedOperatorButton("÷")
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        calc.tappedEqualButton()
    }

    @IBAction func tappedResetButton(_ sender: UIButton) {
        calc.tappedResetButton()
    }

}

extension ViewController: CalculationDelegate {
    func updateCalculText(_ text: String) {
        textView.text = text
    }

    func displayAlert(_ text: String) {
        let alertVC = UIAlertController(title: "Zéro!",
                                        message: text, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return self.present(alertVC, animated: true, completion: nil)
    }
}
