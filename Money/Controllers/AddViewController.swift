//
//  AddViewController.swift
//  Money
//
//  Created by Igor Rastegaev on 07.02.2021.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet var calculatorButtons: [UIButton]!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let realm = try! Realm()
    let manageUI = Design()
    var firstValue: Double = 0
    var secondValue: Double = 0
    var currentSign = ""
    var resetLabelText = false
    var category: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        manageUI.manageView(containerView)
        containerView.layer.cornerRadius = 25
        
        manageUI.manageView(categoryView)
        categoryView.isHidden = true
        self.categoryView.alpha = 0
        
        valueLabel.adjustsFontSizeToFitWidth = true
        
        for button in calculatorButtons {
            button.backgroundColor = .clear
            button.layer.borderWidth = 2
            button.layer.borderColor = manageUI.hexStringToUIColor(hex: "eb4d4b").cgColor
            button.layer.cornerRadius = 15

        }
        
        if let category = category {
            categoryButton.imageView?.image = UIImage(named: category)
            self.title = category.capitalized
        }
        
    }
    
    @IBAction func numButtonPressed(_ sender: UIButton) {
        
        if currentSign == "" {
            if valueLabel.text == "0" {
                valueLabel.text = sender.currentTitle
            } else {
                valueLabel.text! += sender.currentTitle!
            }
        } else {
            if resetLabelText || valueLabel.text == "0" {
                valueLabel.text = sender.currentTitle
                resetLabelText = false
            } else {
                valueLabel.text! += sender.currentTitle!
            }
        }
                
    }
    
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        
        switch sender.tag {
        
        // Plus sign pressed
        case 0:
            calculate(currentSign)
            currentSign = "+"
        // Minus sign pressed
        case 1:
            calculate(currentSign)
            currentSign = "-"
        // Multiply sign pressed
        case 2:
            calculate(currentSign)
            currentSign = "*"
        // Devide sign pressed
        case 3:
            calculate(currentSign)
            currentSign = "/"
        // Equal sign pressed
        case 4:
            secondValue = Double(valueLabel.text!)!
            switch currentSign {
            case "+":
                valueLabel.text = String(firstValue + secondValue)
                firstValue = firstValue + secondValue
            case "-":
                valueLabel.text = String(firstValue - secondValue)
                firstValue = firstValue - secondValue
            case "*":
                valueLabel.text = String(firstValue * secondValue)
                firstValue = firstValue * secondValue
            case "/":
                valueLabel.text = String(firstValue / secondValue)
                firstValue = firstValue / secondValue
            default:
                return
            }
            currentSign = ""
        default:
            return
        }
        
    }
    
    func calculate(_ currentSign: String) {
        
        switch currentSign {
        case "":
            firstValue = Double(valueLabel.text!)!
            valueLabel.text = "0"
        case "+":
            resetLabelText = true
            let answer = firstValue + Double(valueLabel.text!)!
            let roundedAnswer = Double(round(100*answer)/100)
            valueLabel.text = String(roundedAnswer)
            firstValue = roundedAnswer
        case "-":
            resetLabelText = true
            let answer = firstValue - Double(valueLabel.text!)!
            let roundedAnswer = Double(round(100*answer)/100)
            valueLabel.text = String(roundedAnswer)
            firstValue = roundedAnswer
        case "*":
            resetLabelText = true
            let answer = firstValue * Double(valueLabel.text!)!
            let roundedAnswer = Double(round(100*answer)/100)
            valueLabel.text = String(roundedAnswer)
            firstValue = roundedAnswer
        case "/":
            resetLabelText = true
            let answer = firstValue / Double(valueLabel.text!)!
            let roundedAnswer = Double(round(100*answer)/100)
            valueLabel.text = String(roundedAnswer)
            firstValue = roundedAnswer
        default:
           return
        }
        
    }
    
    
    @IBAction func dotPressed(_ sender: UIButton) {
        if !valueLabel.text!.contains(".") {
            valueLabel.text! += "."
        }
    }
    
    
    @IBAction func backspacePressed(_ sender: UIButton) {
        
        if valueLabel.text != "0" {

            let count = valueLabel.text?.count
            var counter = 0
            var newNumber = ""

            if count == 1 {
                valueLabel.text = "0"
            } else {
                for num in valueLabel.text! {
                    counter += 1
                    if counter == count {
                        valueLabel.text = newNumber
                        return
                    } else {
                        newNumber += String(num)
                    }
                }
            }

        }
        
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        
        if valueLabel.text == "0" || valueLabel.text == "0.0" {
            performAlert(message: "Please, set the value of transaction")
        } else {
            
            let newTransaction = Transaction()
            
            if let category = category, let value = valueLabel.text {
                newTransaction.category = category
                if let value = Double(value) {
                    newTransaction.value = String(value)
                }
            }
            
            let date = datePicker.date
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM"
            newTransaction.month = formatter.string(from: date)
            formatter.dateFormat = "d MMM"
            newTransaction.date = formatter.string(from: date)
            
            realm.beginWrite()
            realm.add(newTransaction)
            try! realm.commitWrite()
            
            performAlert(message: "You've successfully added a new transaction!")
        }
        
    }
    
    @IBAction func selectCategoryPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.categoryView.isHidden = false
            self.categoryView.alpha = 1
        })
    }
    
    @IBAction func categoryPressed(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.categoryView.alpha = 0
        })
        
        if let categoryName = sender.restorationIdentifier {
            categoryButton.imageView?.image = UIImage(named: categoryName)
            category = categoryName
        }
    }
    
    func performAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action) in
            self.navigationController?.popViewController(animated: true)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
}

