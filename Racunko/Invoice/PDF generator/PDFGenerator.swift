//
//  PDFGenerator.swift
//  Racunko
//
//  Created by Nikola on 11/09/2018.
//  Copyright © 2018 Nikola. All rights reserved.
//

import Foundation
import UIKit
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
            HTMLContent = HTMLContent
                .replacingOccurrences(of: "{company_name}", with: business.name ?? "")
                .replacingOccurrences(of: "{company_address}", with: business.address ?? "")
                .replacingOccurrences(of: "{company_city_zip_state}", with: " ● \(business.zipCity ?? "")")
                .replacingOccurrences(of: "{company_phone_fax}", with: business.phone ?? "")
                .replacingOccurrences(of: "{company_email_web}", with: " ● \(business.web ?? "") ● \(business.email ?? "")")
            
            // Invoice details
            let itemsString = NSMutableString()
            var index = 1
            let items = invoice.invoiceItems?.allObjects as? [InvoiceItem] ?? []
            try? items.forEach { invoiceItem in
                var HTMLItem = try String(contentsOfFile: pathToItem)
                HTMLItem = HTMLItem
                    .replacingOccurrences(of: "{item_row_number}", with: "\(index)")
                    .replacingOccurrences(of: "{item_description}", with: invoiceItem.title ?? "")
                    .replacingOccurrences(of: "{item_quantity}", with: "\(invoiceItem.amount)")
                    .replacingOccurrences(of: "{item_price}", with: CurrencyFormatter.string(from: NSNumber(value: invoiceItem.price)) ?? "")
                    .replacingOccurrences(of: "{item_line_total}", with: CurrencyFormatter.string(from: NSNumber(value: invoiceItem.totalPrice)) ?? "")
                index += 1
                itemsString.append(HTMLItem)
            }
            
            HTMLContent = HTMLContent
                .replacingOccurrences(of: "{company_logo}", with: getLogoPath())
                .replacingOccurrences(of: "{bg_image}", with: "img/bg.png")
                .replacingOccurrences(of: "{sum-pozadina_image}", with: "img/sum-pozadina.png")
                .replacingOccurrences(of: "{invoice_item}", with: String(itemsString))
                .replacingOccurrences(of: "{invoice_number}", with: invoice.number ?? "")
                .replacingOccurrences(of: "{client_name}", with: invoice.client?.name ?? "")
                .replacingOccurrences(of: "{client_address}", with: invoice.client?.address ?? "")
                .replacingOccurrences(of: "{client_city_zip_state}", with: invoice.client?.city ?? "")
                .replacingOccurrences(of: "{client_phone_fax}", with: String(invoice.client?.oib ?? 0))
                .replacingOccurrences(of: "{amount_subtotal}", with: CurrencyFormatter.string(from: NSNumber(value: invoice.totalAmount)) ?? "")
                .replacingOccurrences(of: "{amount_total}", with: CurrencyFormatter.string(from: NSNumber(value: invoice.totalAmount)) ?? "")
                .replacingOccurrences(of: "{amount_due}", with: CurrencyFormatter.string(from: NSNumber(value: invoice.totalAmount)) ?? "")
                
                .replacingOccurrences(of: "{issue_date}", with: DateFormat.string(from: invoice.createdAt ?? Date()))
                .replacingOccurrences(of: "{due_date}", with: DateFormat.string(from: invoice.date ?? Date()))
                .replacingOccurrences(of: "{terms}", with: invoice.footnote ?? (business.defaultFootNote ?? ""))
                .replacingOccurrences(of: "{payment_info1}", with: invoice.paymentType ?? (business.defaultPaymentType ?? ""))
                .replacingOccurrences(of: "{payment_info2}", with: String(""))
                .replacingOccurrences(of: "{payment_info3}", with: String(""))
                .replacingOccurrences(of: "{payment_info4}", with: String(""))
                .replacingOccurrences(of: "{payment_info5}", with: String(""))
            
            return HTMLContent
        } catch {
            print("Unable to open HTML template file")
        }
        return nil
    }
    
    func exportHTMLToPDF(_ htmlContent: String?) {
        guard let htmlContent = htmlContent else {
            print("No HTML content")
            return
        }
        let printPageRenderer = PrintPageRenderer()
        let printFormatter = UIMarkupTextPrintFormatter(markupText: htmlContent)
        print(printFormatter.markupText)
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        
        guard let pdfData = drawPDFUsingPrintPageRenderer(printPageRenderer) else {
            print("error drawing pdf using print page renderer")
            return
        }
        
        let invoiceNumber = invoice.number ?? "New"
        guard let outputURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(invoiceNumber).appendingPathExtension("pdf") else { return }
        
        pdfData.write(to: outputURL, atomically: true)
        print(outputURL.path)
    }
    
    private func drawPDFUsingPrintPageRenderer(_ printPageRenderer: UIPrintPageRenderer) -> NSData! {
        let data = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(data, .zero, nil)
        
        for i in 0..<printPageRenderer.numberOfPages {
            UIGraphicsBeginPDFPage();
            printPageRenderer.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
        }
        
        UIGraphicsEndPDFContext();
        
        return data
    }
    
    private func getLogoPath() -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let logoPath = path + "/logo.png"
        
        if FileManager.default.fileExists(atPath: logoPath) {
            return logoPath
        } else if let logoPath = Bundle(for: PDFGenerator.self).path(forResource: "img/nologo", ofType: "png") {
            return logoPath
        }
        return ""
    }
}
