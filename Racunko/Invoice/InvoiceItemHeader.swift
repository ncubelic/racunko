//
//  InvoiceItemHeader.swift
//  Racunko
//
//  Created by Nikola on 5.1.2019..
//  Copyright © 2019 Nikola. All rights reserved.
//

import UIKit

protocol InvoiceItemHeaderDelegate {
    func invoiceItemHeaderDidAddItem()
}

class InvoiceItemHeader: UITableViewCell {

    var delegate: InvoiceItemHeaderDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func addInvoiceItem(_ sender: Any) {
        delegate?.invoiceItemHeaderDidAddItem()
    }
    
}
