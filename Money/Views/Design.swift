//
//  ManageUI.swift
//  Money
//
//  Created by Igor Rastegaev on 07.02.2021.
//

import UIKit

struct Design {
    
    static let colors = [
        "transport" : "#EAB543",
        "health" : "#e55039",
        "car" : "#4a69bd",
        "pets" : "#95a5a6",
        "bills" : "#27ae60",
        "calls" : "#D980FA",
        "gifts" : "#9980FA",
        "housing" : "#34495e",
        "meal" : "#1e3799",
        "fun" : "#B53471",
        "products" : "#079992",
        "clothes" : "#006266",
        "sport" : "#fa983a",
        "purchases" : "#833471",
        "income" : "#E0B22C"
    ]
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func manageButton(_ button: UIButton) {
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 3
    }
    
    func manageView(_ view: UIView) {
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 3
    }
    
}

