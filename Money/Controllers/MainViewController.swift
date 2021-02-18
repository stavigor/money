//
//  ViewController.swift
//  Money
//
//  Created by Igor Rastegaev on 05.02.2021.
//

import UIKit
import Charts
import RealmSwift

class MainViewController: UIViewController {

    @IBOutlet weak var monthButton: UIButton!
    @IBOutlet var categoriesButtonsArray: [UIButton]!
    @IBOutlet weak var balanceButton: UIButton!
    @IBOutlet var charView: PieChartView!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var expansesLabel: UILabel!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet var categoryLabelCollection: [UILabel]!
    @IBOutlet weak var centralView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerContainerView: UIView!
    
    var transportDataEntry = PieChartDataEntry(value: 0)
    var productsDataEntry = PieChartDataEntry(value: 0)
    var mealDataEntry = PieChartDataEntry(value: 0)
    var purchasesDataEntry = PieChartDataEntry(value: 0)
    var housingDataEntry = PieChartDataEntry(value: 0)
    var giftsDataEntry = PieChartDataEntry(value: 0)
    var sportDataEntry = PieChartDataEntry(value: 0)
    var callsDataEntry = PieChartDataEntry(value: 0)
    var clothesDataEntry = PieChartDataEntry(value: 0)
    var funDataEntry = PieChartDataEntry(value: 0)
    var petsDataEntry = PieChartDataEntry(value: 0)
    var carDataEntry = PieChartDataEntry(value: 0)
    var healthDataEntry = PieChartDataEntry(value: 0)
    var billsDataEntry = PieChartDataEntry(value: 0)
    var arrayDataEntry = [PieChartDataEntry]()
    
    let realm = try! Realm()
    let manageUI = Design()
    var selectedCategory: String?
    var categoriesArray = [String]()
    var valuesArray = [Double]()
    var income = 0.0
    var balance: String?
    let scrollView = UIScrollView()
    var counter = 0
    var currentMonth: String?
    var monthArray = [String]()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if Core.shared.isNewUser() {
            // show onboarding
            if #available(iOS 13.0, *) {
                let vc = storyboard?.instantiateViewController(identifier: "welcome") as! OnboardingViewController
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMonth()
        
        pickerContainerView.isHidden = true
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        for label in categoryLabelCollection {
            label.adjustsFontSizeToFitWidth = true
        }
        
        manageUI.manageView(buttonView)
        manageUI.manageView(pickerContainerView)
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        currentMonth = formatter.string(from: date)
        if let currentMonth = currentMonth {
            monthButton.setTitle(currentMonth, for: .normal)
            getRealmData(for: currentMonth)
            setChart()
            updateData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let currentMonth = currentMonth {
            getRealmData(for: currentMonth)
            updateData()
        }
        
    }
    
    func getRealmData(for currentMonth: String) {
        categoriesArray = [String]()
        valuesArray = [Double]()
        
        let transactions = realm.objects(Transaction.self)
        for transaction in transactions {
            
            if transaction.month == currentMonth {
                if transaction.category == "income" {
                    if let value = Double(transaction.value) {
                        income = value
                        incomeLabel.text = String(income)
                    }
                } else if !categoriesArray.contains(transaction.category) {
                    categoriesArray.append(transaction.category)
                    if let value = Double(transaction.value) {
                        valuesArray.append(value)
                    }
                } else {
                    var counter = 0
                    for category in categoriesArray {
                        if category == transaction.category {
                            break
                        }
                        counter += 1
                    }
                    if let value = Double(transaction.value) {
                        valuesArray[counter] += value
                    }
                }
            }
            
            
            
        }
        
        var expanse = 0.0
        for value in valuesArray {
            expanse += value
        }
        expansesLabel.text = String(expanse)
        
        balanceButton.setTitle("Balance: \(income - expanse)", for: .normal)
        balanceButton.titleLabel?.adjustsFontSizeToFitWidth = true
        

        print(categoriesArray)
        print(valuesArray)
    }
    
    func setChart() {
        charView.holeColor = .clear
        
        charView.chartDescription?.text = ""
        
        transportDataEntry.value = 0
        transportDataEntry.label = ""
        productsDataEntry.value = 0
        mealDataEntry.value = 0
        purchasesDataEntry.value = 0
        housingDataEntry.value = 0
        giftsDataEntry.value = 0
        sportDataEntry.value = 0
        callsDataEntry.value = 0
        clothesDataEntry.value = 0
        funDataEntry.value = 0
        petsDataEntry.value = 0
        carDataEntry.value = 0
        healthDataEntry.value = 0
        billsDataEntry.value = 0
        
        arrayDataEntry = [transportDataEntry, productsDataEntry, mealDataEntry, purchasesDataEntry, housingDataEntry, giftsDataEntry, sportDataEntry, callsDataEntry, clothesDataEntry, funDataEntry, petsDataEntry, carDataEntry, healthDataEntry, billsDataEntry]
        
        updateChart()
    }
    
    func updateChart() {
        let chartDataSet = PieChartDataSet(entries: arrayDataEntry, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        chartData.setDrawValues(false)
        chartDataSet.colors = [
            manageUI.hexStringToUIColor(hex: Design.colors["transport"]!),
            manageUI.hexStringToUIColor(hex: Design.colors["products"]!),
            manageUI.hexStringToUIColor(hex: Design.colors["meal"]!),
            manageUI.hexStringToUIColor(hex: Design.colors["purchases"]!),
            manageUI.hexStringToUIColor(hex: Design.colors["housing"]!),
            manageUI.hexStringToUIColor(hex: Design.colors["gifts"]!),
            manageUI.hexStringToUIColor(hex: Design.colors["sport"]!),
            manageUI.hexStringToUIColor(hex: Design.colors["calls"]!),
            manageUI.hexStringToUIColor(hex: Design.colors["clothes"]!),
            manageUI.hexStringToUIColor(hex: Design.colors["fun"]!),
            manageUI.hexStringToUIColor(hex: Design.colors["pets"]!),
            manageUI.hexStringToUIColor(hex: Design.colors["car"]!),
            manageUI.hexStringToUIColor(hex: Design.colors["health"]!),
            manageUI.hexStringToUIColor(hex: Design.colors["bills"]!)
        ]
        
        charView.data = chartData
    }
    
    func updateData() {
        
        for categoryLabel in categoryLabelCollection {
            categoryLabel.text = "0"
        }
        
        transportDataEntry.value = 0
        productsDataEntry.value = 0
        mealDataEntry.value = 0
        purchasesDataEntry.value = 0
        housingDataEntry.value = 0
        giftsDataEntry.value = 0
        sportDataEntry.value = 0
        callsDataEntry.value = 0
        clothesDataEntry.value = 0
        funDataEntry.value = 0
        petsDataEntry.value = 0
        carDataEntry.value = 0
        healthDataEntry.value = 0
        billsDataEntry.value = 0
        
        var counter = 0
        for category in categoriesArray {
            switch category {
            case "transport":
                transportDataEntry.value = valuesArray[counter]
                setCategoryLabel(category: "transportLabel", value: valuesArray[counter])
            case "products":
                productsDataEntry.value = valuesArray[counter]
                setCategoryLabel(category: "productsLabel", value: valuesArray[counter])
            case "meal":
                mealDataEntry.value = valuesArray[counter]
                setCategoryLabel(category: "mealLabel", value: valuesArray[counter])
            case "purchases":
                purchasesDataEntry.value = valuesArray[counter]
                setCategoryLabel(category: "purchasesLabel", value: valuesArray[counter])
            case "housing":
                housingDataEntry.value = valuesArray[counter]
                setCategoryLabel(category: "housingLabel", value: valuesArray[counter])
            case "gifts":
                giftsDataEntry.value = valuesArray[counter]
                setCategoryLabel(category: "giftsLabel", value: valuesArray[counter])
            case "sport":
                sportDataEntry.value = valuesArray[counter]
                setCategoryLabel(category: "sportLabel", value: valuesArray[counter])
            case "calls":
                callsDataEntry.value = valuesArray[counter]
                setCategoryLabel(category: "callsLabel", value: valuesArray[counter])
            case "clothes":
                clothesDataEntry.value = valuesArray[counter]
                setCategoryLabel(category: "clothesLabel", value: valuesArray[counter])
            case "fun":
                funDataEntry.value = valuesArray[counter]
                setCategoryLabel(category: "funLabel", value: valuesArray[counter])
            case "pets":
                petsDataEntry.value = valuesArray[counter]
                setCategoryLabel(category: "petsLabel", value: valuesArray[counter])
            case "car":
                carDataEntry.value = valuesArray[counter]
                setCategoryLabel(category: "carLabel", value: valuesArray[counter])
            case "health":
                healthDataEntry.value = valuesArray[counter]
                setCategoryLabel(category: "healthLabel", value: valuesArray[counter])
            default:
                billsDataEntry.value = valuesArray[counter]
                setCategoryLabel(category: "billsLabel", value: valuesArray[counter])
            }
            counter += 1
        }
        updateChart()
    }
    
    func getMonth() {
        let transactions = realm.objects(Transaction.self)
        for transaction in transactions {
            if !monthArray.contains(transaction.month) {
                monthArray.append(transaction.month)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainToAdd" {
            let destination = segue.destination as! AddViewController
            destination.category = selectedCategory
        } else if segue.identifier == "mainToHistory" {
            let destination = segue.destination as! HistoryViewController
            if let balance = balance {
                destination.balance = balance
            }
        }
    }
    
    @IBAction func categoryPressed(_ sender: UIButton) {
        selectedCategory = sender.restorationIdentifier
        performSegue(withIdentifier: "mainToAdd", sender: self)
    }
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        selectedCategory = "income"
        performSegue(withIdentifier: "mainToAdd", sender: self)
    }
    
    @IBAction func minusButtonPressed(_ sender: UIButton) {
        selectedCategory = "transport"
        performSegue(withIdentifier: "mainToAdd", sender: self)
    }
    
    @IBAction func balancePressed(_ sender: UIButton) {
        balance = sender.currentTitle
        performSegue(withIdentifier: "mainToHistory", sender: self)
    }
    
    func setCategoryLabel(category: String, value: Double) {
        for label in categoryLabelCollection {
            if label.restorationIdentifier == category {
                label.text = String(value)
            }
        }
    }
    
    @IBAction func monthPressed(_ sender: UIButton) {
        if pickerContainerView.isHidden {
            pickerContainerView.isHidden = false
        } else {
            pickerContainerView.isHidden = true
        }
    }
    
}

//MARK: - UIPickerView

extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return monthArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return monthArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        monthButton.setTitle(monthArray[row], for: .normal)
        currentMonth = monthArray[row]
        if let currentMonth = currentMonth {
            getRealmData(for: currentMonth)
            updateData()
        }
    }
    
}

//MARK: - Core

class Core {
    
    static let shared = Core()
    
    func isNewUser() -> Bool {
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    ///
    func setIsNotNewUser() {
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
}
