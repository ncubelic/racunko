//
//  TextFieldCell.swift
//  Racunko
//
//  Created by Nikola on 22/01/2019.
//  Copyright © 2019 Nikola. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(with item: Item) {
        if case ItemType.textField(let placeholder, let value) = item.type {
            descriptionLabel.text = item.title
            let formattedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            textField.attributedPlaceholder = formattedPlaceholder
            textField.text = value
        }
    }
    
}
