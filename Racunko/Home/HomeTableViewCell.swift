//
//  HomeTableViewCell.swift
//  Racunko
//
//  Created by Nikola on 25/01/2019.
//  Copyright © 2019 Nikola. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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

}
