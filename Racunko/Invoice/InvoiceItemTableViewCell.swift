//
//  InvoiceItemTableViewCell.swift
//  Racunko
//
//  Created by Nikola on 04/01/2019.
//  Copyright © 2019 Nikola. All rights reserved.
//

import UIKit

class InvoiceItemTableViewCell: UITableViewCell {

    @IBOutlet weak var totalAmountTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var cellNumberLabel: UILabel!
//    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(with invoiceItem: InvoiceItemModel) {
        // TODO: item description
//        descriptionTextView.text = invoiceItem.description
        priceTextField.text = CurrencyFormatter.string(from: NSNumber(value: invoiceItem.price))
        amountTextField.text = String(invoiceItem.amount)
        totalAmountTextField.text = CurrencyFormatter.string(from: NSNumber(value: invoiceItem.totalAmount))
    }
    
}
