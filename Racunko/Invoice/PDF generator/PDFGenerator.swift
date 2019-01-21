//
//  PDFGenerator.swift
//  Racunko
//
//  Created by Nikola on 11/09/2018.
//  Copyright © 2018 Nikola. All rights reserved.
//

import Foundation
import QuartzCore

class PDFGenerator {
    
    var pathToTemplate: String
    let invoice: Invoice
    
    init(invoice: Invoice) {
        self.invoice = invoice
        
        let bundle = Bundle.main
        self.pathToTemplate = bundle.path(forResource: "template", ofType: "html")!
    }
    
    func generate() -> String? {
        do {
            var HTMLContent = try String(contentsOfFile: pathToTemplate)
            HTMLContent = HTMLContent.replacingOccurrences(of: "{company_name}", with: "Ingemark d.o.o.")
            return HTMLContent
        } catch {
            print("Unable to open HTML template file")
        }
        return nil
    }
}
