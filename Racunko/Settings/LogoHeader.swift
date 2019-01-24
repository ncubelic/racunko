//
//  LogoHeader.swift
//  Racunko
//
//  Created by Nikola on 24/01/2019.
//  Copyright © 2019 Nikola. All rights reserved.
//

import UIKit

class LogoHeader: UITableViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(with image: UIImage) {
        logoImageView.image = image
    }
    
}
