//
//  InvoiceViewController.swift
//  Racunko
//
//  Created by Nikola on 24/08/2018.
//  Copyright © 2018 Nikola. All rights reserved.
//

import UIKit
import WebKit

protocol InvoiceViewControllerDelegate {
    func webViewDidLoad(viewPrintFormatter printFormatter: UIViewPrintFormatter)
}

class InvoiceViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var delegate: InvoiceViewControllerDelegate?

    var HTMLContent: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.backgroundColor = .white
        webView.navigationDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        renderHTML()
    }
    
    func renderHTML() {
        guard let HTMLContent = HTMLContent else { return }
        guard let pathToHTML = Bundle.main.path(forResource: "template", ofType: "html") else { return }
        webView.loadHTMLString(HTMLContent, baseURL: URL(fileURLWithPath: pathToHTML))
    }

}

extension InvoiceViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.delegate?.webViewDidLoad(viewPrintFormatter: webView.viewPrintFormatter())
        }
    }
}
