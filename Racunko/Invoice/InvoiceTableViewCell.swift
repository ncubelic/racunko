//
//  InvoiceTableViewCell.swift
//  Racunko
//
//  Created by Nikola on 24/08/2018.
//  Copyright © 2018 Nikola. All rights reserved.
//

import UIKit

class InvoiceTableViewCell: UITableViewCell {

    @IBOutlet weak var invoiceNumberLabel: UILabel!
    @IBOutlet weak var invoiceAmountLabel: UILabel!
    @IBOutlet weak var invoiceDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(with invoice: Invoice) {
        invoiceNumberLabel.text = invoice.number
        invoiceAmountLabel.text = String(invoice.totalAmount)
        if let date = invoice.date {
            invoiceDateLabel.text = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)            
        }
    }

}
