//
//  HistoryViewController.swift
//  Money
//
//  Created by Igor Rastegaev on 07.02.2021.
//

import UIKit
import RealmSwift

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var balanceButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    let manageUI = Design()
    var index: Int?
    var balance: String?
    var tableViewData = [CellData]()
    var categoryArray = [String]()
    var valueDict = [String : [[String]]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        manageUI.manageView(buttonView)
        
        balanceButton.titleLabel?.adjustsFontSizeToFitWidth = true
        if let balance = balance {
            balanceButton.setTitle(balance, for: .normal)
        }
        
        getRealmData()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        for category in categoryArray {
            if let values = valueDict[category] {
                if category == "income" {
                    tableViewData = [CellData(opened: false, category: category, sectionData: values)] + tableViewData
                } else {
                    tableViewData.append(CellData(opened: false, category: category, sectionData: values))
                }
            }
        }
        
    }
    
    @IBAction func balanceButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func getRealmData() {
        
        let transactions = realm.objects(Transaction.self)
        for transaction in transactions {
            
            if !categoryArray.contains(transaction.category) {
                categoryArray.append(transaction.category)
                valueDict[transaction.category] = [[transaction.value, transaction.date]]
            } else {
                valueDict[transaction.category]?.append([transaction.value, transaction.date])
            }
            
        }
        
        print(valueDict)
        
    }
    
}

//MARK: - UITableViewDataSource

extension HistoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened {
            return tableViewData[section].sectionData.count + 1
        } else {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! HeaderTableViewCell
            let category = tableViewData[indexPath.section].category
            cell.categoryLabel.text = category.capitalized
            if let hexColor = Design.colors[category] {
                cell.categoryLabel.textColor = manageUI.hexStringToUIColor(hex: hexColor)
            }
            cell.categoryImage.image = UIImage(named: category)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
            cell.valueLabel.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1][0]
            cell.dateLabel.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1][1]
            return cell
        }
        
    }
    
}


//MARK: - UITableViewDelegate

extension HistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableViewData[indexPath.section].opened {
            tableViewData[indexPath.section].opened = false
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none) 
        } else {
            tableViewData[indexPath.section].opened = true
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
        }
    }
    
}

