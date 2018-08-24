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
        invoiceAmountLabel.text = String(invoice.amount)
        invoiceDateLabel.text = DateFormatter.localizedString(from: invoice.date, dateStyle: .medium, timeStyle: .none)
    }

}
