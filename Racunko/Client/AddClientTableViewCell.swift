//
//  AddClientTableViewCell.swift
//  Racunko
//
//  Created by Nikola on 11/09/2018.
//  Copyright © 2018 Nikola. All rights reserved.
//

import UIKit

class AddClientTableViewCell: UITableViewCell {

    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    private let customFont = UIFont(name: "PTSans-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(with item: Item) {
        titleTextLabel?.text = item.title
        switch item.type {
        case .textField(let placeholder, let text):
            let attributedString = NSAttributedString(string: placeholder, attributes: [.font: customFont, .foregroundColor: UIColor.lightGray])
            textField.attributedPlaceholder = attributedString
            textField.text = text
            textField.isEnabled = true
        default:
            print("unimplemented type")
        }
    }

}
