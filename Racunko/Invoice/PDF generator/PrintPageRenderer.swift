//
//  PrintPageRenderer.swift
//  Racunko
//
//  Created by Nikola on 25/01/2019.
//  Copyright © 2019 Nikola. All rights reserved.
//

import Foundation
import UIKit

class PrintPageRenderer: UIPrintPageRenderer {
    
    let A4PageWidth: CGFloat = 595.2
    let A4PageHeight: CGFloat = 841.8
    
    override init() {
        super.init()
        
        let pageFrame = CGRect(origin: .zero, size: CGSize(width: A4PageWidth, height: A4PageHeight))
        self.setValue(pageFrame, forKey: "paperRect")
//        self.setValue(pageFrame, forKey: "printableRect")
        
    }
}
