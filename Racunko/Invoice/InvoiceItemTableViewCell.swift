//
//  InvoiceItemTableViewCell.swift
//  Racunko
//
//  Created by Nikola on 04/01/2019.
//  Copyright © 2019 Nikola. All rights reserved.
//

import UIKit

let currencyFormatter = NumberFormatter()

class InvoiceItemTableViewCell: UITableViewCell {

    @IBOutlet weak var totalAmountTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var cellNumberLabel: UILabel!
//    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "hr_HR")
        currencyFormatter.currencyCode = "HRK"
        currencyFormatter.currencySymbol = "kn"
        currencyFormatter.currencyDecimalSeparator = ","
        currencyFormatter.currencyGroupingSeparator = "."
        currencyFormatter.minimumFractionDigits = 2
        currencyFormatter.maximumFractionDigits = 2
        currencyFormatter.minimumIntegerDigits = 1
    }

    func setup(with invoiceItem: InvoiceItem) {
//        descriptionTextView.text = invoiceItem.description
        priceTextField.text = currencyFormatter.string(from: NSNumber(value: invoiceItem.price))
        amountTextField.text = String(invoiceItem.amount)
        totalAmountTextField.text = currencyFormatter.string(from: NSNumber(value: invoiceItem.totalAmount))
    }
    
}
