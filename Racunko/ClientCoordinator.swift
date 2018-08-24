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
    
    required init(rootViewController: UISplitViewController, dependencyManager: DependencyManager) {
        self.rootViewController = rootViewController
        self.dependencyManager = dependencyManager
    }
    
    func start() {
        let clientListVC = UIStoryboard(name: "Invoice", bundle: nil).instantiate(ClientListViewController.self)
        clientListVC.delegate = self
        masterNavigationController.navigationBar.prefersLargeTitles = true
        masterNavigationController.setViewControllers([clientListVC], animated: false)
        
        let invoiceVC = UIStoryboard(name: "Invoice", bundle: nil).instantiate(InvoiceViewController.self)
        detailsNavigationController.setViewControllers([invoiceVC], animated: false)
        detailsNavigationController.title = "1-1-1"

        rootViewController.viewControllers = [masterNavigationController, detailsNavigationController]
    }
}


extension ClientCoordinator: ClientListViewControllerDelegate {
    
    func didSelectCompany(_ company: Company) {
        let invoiceListVC = UIStoryboard(name: "Invoice", bundle: nil).instantiate(InvoiceListViewController.self)
        masterNavigationController.pushViewController(invoiceListVC, animated: true)
    }
}


extension UISplitViewController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
