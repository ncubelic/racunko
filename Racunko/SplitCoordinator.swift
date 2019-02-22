//
//  SplitCoordinator.swift
//  Racunko
//
//  Created by Nikola on 21/01/2019.
//  Copyright © 2019 Nikola. All rights reserved.
//

import Foundation
import UIKit

class SplitViewCoordinator: NSObject, SplitCoordinator {
    
    var rootViewController: UISplitViewController
    var childCoordinators: [Coordinator] = []
    var dependencyManager: DependencyManager
    
    private var masterNavigationController = UINavigationController()
    private var detailsNavigationController = UINavigationController()
    
    private var currentInvoiceFormatter: UIViewPrintFormatter?
    private var currentInvoice: Invoice?
    
    required init(rootViewController: UISplitViewController, dependencyManager: DependencyManager) {
        self.rootViewController = rootViewController
        self.dependencyManager = dependencyManager
    }
    
    func start() {
        let homeCoordinator = HomeCoordinator(rootViewController: masterNavigationController, dependencyManager: dependencyManager)
        addChildCoordinator(homeCoordinator)
        homeCoordinator.start()
        homeCoordinator.delegate = self
        
        let detailsCoordinator = DetailsCoordinator(rootViewController: detailsNavigationController, dependencyManager: dependencyManager)
        addChildCoordinator(detailsCoordinator)
        detailsCoordinator.start()
        
        rootViewController.viewControllers = [masterNavigationController, detailsNavigationController]
        masterNavigationController.view.backgroundColor = .secondaryDark
    }
}

extension SplitViewCoordinator: HomeCoordinatorDelegate {
    
    func showClients() {
        let clientCoordinator = ClientCoordinator(rootViewController: masterNavigationController, dependencyManager: dependencyManager)
        addChildCoordinator(clientCoordinator)
        clientCoordinator.delegate = self
        clientCoordinator.start()
    }
    
    func showSettings() {
        let settingsCoordinator = SettingsCoordinator(rootViewController: detailsNavigationController, dependencyManager: dependencyManager)
        addChildCoordinator(settingsCoordinator)
        settingsCoordinator.start()
    }
    
    func showAllInvoices() {
        let invoiceCoordinator = InvoiceCoordinator(rootViewController: masterNavigationController, dependencyManager: dependencyManager)
        invoiceCoordinator.delegate = self
        invoiceCoordinator.start()
        childCoordinators.append(invoiceCoordinator)
    }
}

extension SplitViewCoordinator: ClientCoordinatorDelegate {
    
    func shouldPreview(_ invoice: Invoice) {
        currentInvoice = invoice
        loadHTML(invoice)
    }
}

extension SplitViewCoordinator: InvoiceCoordinatorDelegate {
   
    func shouldShow(invoice: Invoice) {
        currentInvoice = invoice
        loadHTML(invoice)
    }
    
    @objc func createPDF() {
        guard
            let currentInvoiceFormatter = currentInvoiceFormatter,
            let invoice = currentInvoice
            else { return }
        
        let filename = invoice.number ?? UUID().uuidString
        
        let pdfGenerator = PDFGenerator()
        pdfGenerator.exportPDF(using: currentInvoiceFormatter, with: filename)
    }
}

extension SplitViewCoordinator: InvoiceViewControllerDelegate {
    
    func webViewDidLoad(viewPrintFormatter formatter: UIViewPrintFormatter) {
        currentInvoiceFormatter = formatter
    }
}

extension SplitViewCoordinator {
    
    func loadHTML(_ invoice: Invoice) {
        guard let myCompany = dependencyManager.coreDataManager.getBusiness().first else {
            print("My company details are not stored in core data")
            return
        }
        let invoiceVC = UIStoryboard(name: "Invoice", bundle: nil).instantiate(InvoiceViewController.self)
        invoiceVC.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(createPDF))
        let htmlGenerator = HTMLGenerator(invoice: invoice, myCompanyDetails: myCompany)
        invoiceVC.delegate = self
        invoiceVC.HTMLContent = htmlGenerator.generateHTML()
        invoiceVC.title = invoice.number
        detailsNavigationController.setViewControllers([invoiceVC], animated: false)
    }
}
