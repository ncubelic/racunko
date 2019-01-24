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
    
    let pathToTemplate: String
    let pathToItem: String
    let invoice: Invoice
    let business: Business
    
    init(invoice: Invoice, myCompanyDetails: Business) {
        self.invoice = invoice
        self.business = myCompanyDetails
        
        let bundle = Bundle.main
        self.pathToTemplate = bundle.path(forResource: "template", ofType: "html")!
        self.pathToItem = bundle.path(forResource: "item", ofType: "html")!
    }
    
    func generateHTML() -> String? {
        do {
            var HTMLContent = try String(contentsOfFile: pathToTemplate)
            
            // Obrt details
            HTMLContent = HTMLContent.replacingOccurrences(of: "{company_name}", with: business.name ?? "")
            HTMLContent = HTMLContent.replacingOccurrences(of: "{company_address}", with: business.address ?? "")
            HTMLContent = HTMLContent.replacingOccurrences(of: "{company_city_zip_state}", with: " ● \(business.zipCity ?? "")")
            HTMLContent = HTMLContent.replacingOccurrences(of: "{company_phone_fax}", with: business.phone ?? "")
            HTMLContent = HTMLContent.replacingOccurrences(of: "{company_email_web}", with: " ● \(business.web ?? "") ● \(business.email ?? "")")
            
            if let logoPath = Bundle(for: PDFGenerator.self).path(forResource: "img/logo", ofType: "png") {
                HTMLContent = HTMLContent.replacingOccurrences(of: "{company_logo}", with: logoPath)
            } else if let logoPath = Bundle(for: PDFGenerator.self).path(forResource: "img/nologo", ofType: "png") {
                HTMLContent = HTMLContent.replacingOccurrences(of: "{company_logo}", with: logoPath)
            }
            
            // Invoice details
            let itemsString = NSMutableString()
            var index = 1
            let items = invoice.invoiceItems?.allObjects as? [InvoiceItem] ?? []
            try? items.forEach { invoiceItem in
                var HTMLItem = try String(contentsOfFile: pathToItem)
                HTMLItem = HTMLItem.replacingOccurrences(of: "{item_row_number}", with: "\(index)")
                HTMLItem = HTMLItem.replacingOccurrences(of: "{item_description}", with: invoiceItem.title ?? "")
                HTMLItem = HTMLItem.replacingOccurrences(of: "{item_quantity}", with: "\(invoiceItem.amount)")
                HTMLItem = HTMLItem.replacingOccurrences(of: "{item_price}", with: CurrencyFormatter.string(from: NSNumber(value: invoiceItem.price)) ?? "")
                HTMLItem = HTMLItem.replacingOccurrences(of: "{item_line_total}", with: CurrencyFormatter.string(from: NSNumber(value: invoiceItem.totalPrice)) ?? "")
                index += 1
                itemsString.append(HTMLItem)
            }
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "{invoice_item}", with: String(itemsString))
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "{invoice_number}", with: invoice.number ?? "")
            HTMLContent = HTMLContent.replacingOccurrences(of: "{client_name}", with: invoice.client?.name ?? "")
            HTMLContent = HTMLContent.replacingOccurrences(of: "{client_address}", with: invoice.client?.address ?? "")
            HTMLContent = HTMLContent.replacingOccurrences(of: "{client_city_zip_state}", with: invoice.client?.city ?? "")
            HTMLContent = HTMLContent.replacingOccurrences(of: "{client_phone_fax}", with: String(invoice.client?.oib ?? 0))
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "{amount_subtotal}", with: CurrencyFormatter.string(from: NSNumber(value: invoice.totalAmount)) ?? "")
            HTMLContent = HTMLContent.replacingOccurrences(of: "{amount_total}", with: CurrencyFormatter.string(from: NSNumber(value: invoice.totalAmount)) ?? "")
            HTMLContent = HTMLContent.replacingOccurrences(of: "{amount_due}", with: CurrencyFormatter.string(from: NSNumber(value: invoice.totalAmount)) ?? "")
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "{issue_date}", with: DateFormat.string(from: invoice.createdAt ?? Date()))
            HTMLContent = HTMLContent.replacingOccurrences(of: "{due_date}", with: DateFormat.string(from: invoice.date ?? Date()))
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "{terms}", with: invoice.footnote ?? (business.defaultFootNote ?? ""))
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "{payment_info1}", with: invoice.paymentType ?? (business.defaultPaymentType ?? ""))
            HTMLContent = HTMLContent.replacingOccurrences(of: "{payment_info2}", with: String(""))
            HTMLContent = HTMLContent.replacingOccurrences(of: "{payment_info3}", with: String(""))
            HTMLContent = HTMLContent.replacingOccurrences(of: "{payment_info4}", with: String(""))
            HTMLContent = HTMLContent.replacingOccurrences(of: "{payment_info5}", with: String(""))
            
            return HTMLContent
        } catch {
            print("Unable to open HTML template file")
        }
        return nil
    }
}
