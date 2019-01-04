//
//  InvoiceItem.swift
//  Racunko
//
//  Created by Nikola on 04/01/2019.
//  Copyright © 2019 Nikola. All rights reserved.
//

import Foundation

struct InvoiceItem {
    
    var description: String
    var amount: Int
    var price: Double
    var totalAmount: Double
    var discountPercentage: Int? = 0
}

extension InvoiceItem {
    
    init() {
        self.description = "Naziv usluge"
        self.amount = 0
        self.price = 0
        self.totalAmount = 0
        self.discountPercentage = 0
    }
}
