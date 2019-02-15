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
    
    private var previewVC: PreviewViewController
    
    required init(rootViewController: UISplitViewController, dependencyManager: DependencyManager) {
        self.rootViewController = rootViewController
        self.dependencyManager = dependencyManager
        
        previewVC = UIStoryboard(name: "Invoice", bundle: nil).instantiate(PreviewViewController.self)
    }
    
    func start() {
        let homeCoordinator = HomeCoordinator(rootViewController: masterNavigationController, dependencyManager: dependencyManager)
        addChildCoordinator(homeCoordinator)
        homeCoordinator.start()
        homeCoordinator.delegate = self
        
        detailsNavigationController.setViewControllers([previewVC], animated: false)
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
        loadHTML(invoice)
    }
}

extension SplitViewCoordinator: InvoiceCoordinatorDelegate {
   
    func shouldShow(invoice: Invoice) {
        loadHTML(invoice)
    }
    
    @objc func createPDF() {
        // TODO: create pdf on click. You need invoice details and print formatter
    }
}

extension SplitViewCoordinator: InvoiceViewControllerDelegate {
    
    func webViewDidLoad(viewPrintFormatter formatter: UIViewPrintFormatter) {
        let pdfGenerator = PDFGenerator()
        pdfGenerator.exportPDF(using: formatter)
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
        invoiceVC.HTMLContent = htmlGenerator.generateHTML()
        invoiceVC.title = invoice.number
        detailsNavigationController.setViewControllers([invoiceVC], animated: false)
    }
}
