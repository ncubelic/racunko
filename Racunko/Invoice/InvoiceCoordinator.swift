//
//  InvoiceCoordinator.swift
//  Racunko
//
//  Created by Nikola on 31/08/2018.
//  Copyright © 2018 Nikola. All rights reserved.
//

import Foundation
import UIKit

class InvoiceCoordinator: NSObject, NavigationCoordinator {

    var rootViewController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var dependencyManager: DependencyManager
    
    var client: Client?
    
    private var invoiceListVC: InvoiceListViewController
    
    required init(rootViewController: UINavigationController, dependencyManager: DependencyManager) {
        self.rootViewController = rootViewController
        self.dependencyManager = dependencyManager
        
        invoiceListVC = UIStoryboard(name: "Invoice", bundle: nil).instantiate(InvoiceListViewController.self)
    }
    
    func start() {
        guard let client = client else { return }
        showInvoiceList(for: client)
    }
    
    private func showInvoiceList(for client: Client) {
        invoiceListVC.currentClient = client
        invoiceListVC.delegate = self
        invoiceListVC.items2 = dependencyManager.coreDataManager.getInvoices(for: client)
        rootViewController.pushViewController(invoiceListVC, animated: true)
    }
    
    private func showAddInvoice(for client: Client) {
        let addInvoiceVC = UIStoryboard(name: "Invoice", bundle: nil).instantiate(AddInvoiceViewController.self)
        addInvoiceVC.delegate = self
        let navVC = UINavigationController(rootViewController: addInvoiceVC)
        rootViewController.present(navVC, animated: true, completion: nil)
    }
}


// MARK: - InvoiceListViewController delegate

extension InvoiceCoordinator: InvoiceListViewControllerDelegate {
    
    func addNewInvoice(for client: Client) {
        showAddInvoice(for: client)
    }
}


// MARK: - AddInvoiceViewController delegate

extension InvoiceCoordinator: AddInvoiceViewControllerDelegate {
    
    func cancelAction() {
        rootViewController.dismiss(animated: true, completion: nil)
    }
    
    func save(_ invoice: Invoice) {
        rootViewController.dismiss(animated: true, completion: nil)
    }
}
