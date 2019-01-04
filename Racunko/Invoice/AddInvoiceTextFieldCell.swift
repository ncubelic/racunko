//
//  AddInvoiceTextFieldCell.swift
//  Racunko
//
//  Created by Nikola on 04/01/2019.
//  Copyright © 2019 Nikola. All rights reserved.
//

import UIKit

class AddInvoiceTextFieldCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(with item: Item) {
        if case ItemType.textField(let placeholder, let value) = item.type {
            descriptionLabel.text = item.title
            textField.placeholder = placeholder
            textField.text = value
        }
    }

}
