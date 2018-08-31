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
    
    var company: Company?
    
    required init(rootViewController: UINavigationController, dependencyManager: DependencyManager) {
        self.rootViewController = rootViewController
        self.dependencyManager = dependencyManager
    }
    
    func start() {
        guard let company = company else { return }
        showInvoiceList(for: company)
    }
    
    private func showInvoiceList(for company: Company) {
        let invoiceListVC = UIStoryboard(name: "Invoice", bundle: nil).instantiate(InvoiceListViewController.self)
        invoiceListVC.currentCompany = company
        invoiceListVC.delegate = self
        rootViewController.pushViewController(invoiceListVC, animated: true)
    }
    
    private func showAddInvoice(for company: Company) {
        let addInvoiceVC = UIStoryboard(name: "Invoice", bundle: nil).instantiate(AddInvoiceViewController.self)
        addInvoiceVC.delegate = self
        rootViewController.present(addInvoiceVC, animated: true, completion: nil)
    }
}


// MARK: - InvoiceListViewController delegate

extension InvoiceCoordinator: InvoiceListViewControllerDelegate {
    
    func addNewInvoice(for company: Company) {
        showAddInvoice(for: company)
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
