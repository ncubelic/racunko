//
//  InvoiceViewController.swift
//  Racunko
//
//  Created by Nikola on 24/08/2018.
//  Copyright © 2018 Nikola. All rights reserved.
//

import UIKit
import WebKit

class InvoiceViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!

    var HTMLContent: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        renderHTML()
    }
    
    func renderHTML() {
        guard let HTMLContent = HTMLContent else { return }
        guard let pathToHTML = Bundle.main.path(forResource: "template", ofType: "html") else { return }
//        guard let url = URL(fileURLWithPath: pathToHTML) else { return }
        webView.loadHTMLString(HTMLContent, baseURL: URL(fileURLWithPath: pathToHTML))
    }

}
