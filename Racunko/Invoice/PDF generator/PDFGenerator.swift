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
    
    func exportPDF(using printFormatter: UIViewPrintFormatter) {
        let printPageRenderer = PrintPageRenderer()
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        
        guard let pdfData = drawPDFUsingPrintPageRenderer(printPageRenderer) else {
            print("error drawing pdf using print page renderer")
            return
        }
        
        let invoiceNumber = "New" // TODO: dynamic name
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
}
