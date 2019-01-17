//
//  Invoice.swift
//  Racunko
//
//  Created by Nikola on 24/08/2018.
//  Copyright © 2018 Nikola. All rights reserved.
//

import Foundation

struct InvoiceModel {
    
    var number: String
    var createdAt: Date
    var amount: Double
    var date: Date
    var company: Company
    var paymentType: String
    var footNote: String
    var invoiceItems: [InvoiceItemModel] = []
}

extension InvoiceModel {
    
    init(client: Client) {
        self.number = ""
        self.createdAt = Date()
        self.amount = 0
        self.date = Date()
        let company = Company(name: client.name ?? "", oib: Int(client.oib), address: client.address, zip: Int(client.zip), city: client.city ?? "")
        self.company = company
        self.paymentType = "Transakcijski račun"
        self.footNote = ""
    }
}
