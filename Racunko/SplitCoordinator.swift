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
        guard let myCompany = dependencyManager.coreDataManager.getBusiness().first else {
            print("My company details are not stored in core data")
            return
        }
        let invoiceVC = UIStoryboard(name: "Invoice", bundle: nil).instantiate(InvoiceViewController.self)
        let pdfGenerator = PDFGenerator(invoice: invoice, myCompanyDetails: myCompany)
        invoiceVC.HTMLContent = pdfGenerator.generateHTML()
        invoiceVC.title = invoice.number
        detailsNavigationController.setViewControllers([invoiceVC], animated: false)
    }
}

extension SplitViewCoordinator: InvoiceCoordinatorDelegate {
   
    func shouldShow(invoice: Invoice) {
        guard let myCompany = dependencyManager.coreDataManager.getBusiness().first else {
            print("My company details are not stored in core data")
            return
        }
        let invoiceVC = UIStoryboard(name: "Invoice", bundle: nil).instantiate(InvoiceViewController.self)
        let pdfGenerator = PDFGenerator(invoice: invoice, myCompanyDetails: myCompany)
        invoiceVC.HTMLContent = pdfGenerator.generateHTML()
        invoiceVC.title = invoice.number
        detailsNavigationController.setViewControllers([invoiceVC], animated: false)
    }
}
