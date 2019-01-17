//
//  InvoiceItem.swift
//  Racunko
//
//  Created by Nikola on 04/01/2019.
//  Copyright © 2019 Nikola. All rights reserved.
//

import Foundation

struct InvoiceItemModel {
    
    var description: String
    var amount: Int
    var price: Double
    var totalAmount: Double
    var discountPercentage: Int? = 0
}

extension InvoiceItemModel {
    
    init() {
        self.description = "Naziv usluge"
        self.amount = 1
        self.price = 0.0
        self.totalAmount = 0.0
        self.discountPercentage = 0
    }
}
