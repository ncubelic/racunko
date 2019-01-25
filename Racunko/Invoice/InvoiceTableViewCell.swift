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
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backgroundColor = selected ? .secondaryDark : .none
        textLabel?.textColor = .primaryText
        tintColor = .primaryText
    }
    
    func setup(with invoice: Invoice) {
        invoiceNumberLabel.text = invoice.number
        invoiceAmountLabel.text = CurrencyFormatter.string(from: NSNumber(value: invoice.totalAmount))
        if let date = invoice.date {
            invoiceDateLabel.text = DateFormat.string(from: date)
        }
    }

}
