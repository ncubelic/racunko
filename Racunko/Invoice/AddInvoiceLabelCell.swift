//
//  AddInvoiceLabelCell.swift
//  Racunko
//
//  Created by Nikola on 04/01/2019.
//  Copyright © 2019 Nikola. All rights reserved.
//

import UIKit

class AddInvoiceLabelCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(with item: Item) {
        if case ItemType.label(let value) = item.type {
            descriptionLabel.text = item.title
            rightLabel.text = value
        }
    }

}
