//
//  Transaction.swift
//  Money
//
//  Created by Igor Rastegaev on 10.02.2021.
//

import Foundation
import RealmSwift

class Transaction: Object {

    @objc dynamic var value: String = ""
    @objc dynamic var category: String = ""
    @objc dynamic var date: String = ""
    @objc dynamic var month: String = ""
    
}
