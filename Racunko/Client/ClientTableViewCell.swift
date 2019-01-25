//
//  ClientTableViewCell.swift
//  Racunko
//
//  Created by Nikola on 24/08/2018.
//  Copyright © 2018 Nikola. All rights reserved.
//

import UIKit

class ClientTableViewCell: UITableViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companyOibLabel: UILabel!
    @IBOutlet weak var firstLetterLabel: UILabel!
    
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

    func setup(with client: Client) {
        companyNameLabel.text = client.name
        companyOibLabel.text = String(client.oib)
        
        let randomNumber = arc4random_uniform(4)
        logoImageView.image = UIImage(named: "Background-\(randomNumber)")
        if let name = client.name, let char = name.first {
            firstLetterLabel.text = String(char)
        }
    }
}
