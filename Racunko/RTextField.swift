//
//  RTextField.swift
//  Racunko
//
//  Created by Nikola on 25/01/2019.
//  Copyright © 2019 Nikola. All rights reserved.
//

import UIKit

class RTextField: UITextField {

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width - 20, height: bounds.height)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width - 20, height: bounds.height)
    }
}
