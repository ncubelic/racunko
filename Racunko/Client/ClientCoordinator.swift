//
//  ClientCoordinator.swift
//  Racunko
//
//  Created by Nikola on 24/08/2018.
//  Copyright © 2018 Nikola. All rights reserved.
//

import Foundation
import UIKit

class ClientCoordinator: NSObject, SplitCoordinator {
    
    
    var rootViewController: UISplitViewController
    var childCoordinators: [Coordinator] = []
    var dependencyManager: DependencyManager
    
    private var masterNavigationController = UINavigationController()
    private var detailsNavigationController = UINavigationController()
    
    private var clientListVC: ClientListViewController
    
    required init(rootViewController: UISplitViewController, dependencyManager: DependencyManager) {
        self.rootViewController = rootViewController
        self.dependencyManager = dependencyManager
        clientListVC = UIStoryboard(name: "Invoice", bundle: nil).instantiate(ClientListViewController.self)
    }
    
    func start() {
        clientListVC.delegate = self
        clientListVC.items = dependencyManager.coreDataManager.getClients()
        masterNavigationController.setViewControllers([clientListVC], animated: false)
        
        let invoiceVC = UIStoryboard(name: "Invoice", bundle: nil).instantiate(InvoiceViewController.self)
        detailsNavigationController.setViewControllers([invoiceVC], animated: false)
        detailsNavigationController.title = "1-1-1"

        rootViewController.viewControllers = [masterNavigationController, detailsNavigationController]
    }
}


// MARK: - ClientListViewController delegate

extension ClientCoordinator: ClientListViewControllerDelegate {
    
    func didSelectCompany(_ client: Client) {
        let invoiceCoordinator = InvoiceCoordinator(rootViewController: rootViewController, dependencyManager: dependencyManager)
        
        let invoiceListVC = UIStoryboard(name: "Invoice", bundle: nil).instantiate(InvoiceListViewController.self)
        invoiceListVC.items2 = dependencyManager.coreDataManager.getInvoices(for: client)
        masterNavigationController.pushViewController(invoiceListVC, animated: true)
    }
    
    func addNewClient() {
        let addClientVC = UIStoryboard(name: "Invoice", bundle: nil).instantiate(AddClientViewController.self)
        let navVC = UINavigationController(rootViewController: addClientVC)
        addClientVC.delegate = self
        detailsNavigationController.present(navVC, animated: true, completion: nil)
    }
}


// MARK: - AddClientViewController delegate

extension ClientCoordinator: AddClientViewControllerDelegate {
    
    func cancelAction() {
        rootViewController.dismiss(animated: true, completion: nil)
    }
    
    func save(_ client: Company) {
        rootViewController.dismiss(animated: true, completion: nil)
        dependencyManager.coreDataManager.addClient(client)
        clientListVC.updateClients(with: dependencyManager.coreDataManager.getClients()) 
    }
}


// MARK: - SplitViewController

extension UISplitViewController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
