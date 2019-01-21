//
//  ClientCoordinator.swift
//  Racunko
//
//  Created by Nikola on 24/08/2018.
//  Copyright © 2018 Nikola. All rights reserved.
//

import Foundation
import UIKit

protocol ClientCoordinatorDelegate: class {
    func shouldPreview(_ invoice: Invoice)
}

class ClientCoordinator: NSObject, NavigationCoordinator {
    
    var rootViewController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var dependencyManager: DependencyManager
    
    weak var delegate: ClientCoordinatorDelegate?
    
    private var clientListVC: ClientListViewController
    
    required init(rootViewController: UINavigationController, dependencyManager: DependencyManager) {
        self.rootViewController = rootViewController
        self.dependencyManager = dependencyManager
        clientListVC = UIStoryboard(name: "Invoice", bundle: nil).instantiate(ClientListViewController.self)
    }
    
    func start() {
        clientListVC.delegate = self
        clientListVC.items = dependencyManager.coreDataManager.getClients()

        rootViewController.pushViewController(clientListVC, animated: true)
    }
}


// MARK: - ClientListViewController delegate

extension ClientCoordinator: ClientListViewControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    func didSelectCompany(_ client: Client) {
        let invoiceCoordinator = InvoiceCoordinator(rootViewController: rootViewController, dependencyManager: dependencyManager)
        invoiceCoordinator.delegate = self
        invoiceCoordinator.client = client
        invoiceCoordinator.start()
        childCoordinators.append(invoiceCoordinator)
    }
    
    func addNewClient(_ barButton: UIBarButtonItem) {
        let addClientVC = UIStoryboard(name: "Invoice", bundle: nil).instantiate(AddClientViewController.self)
        let navVC = UINavigationController(rootViewController: addClientVC)
        addClientVC.delegate = self
        navVC.modalPresentationStyle = .popover
        let popController = navVC.popoverPresentationController
        popController?.delegate = self
        popController?.barButtonItem = barButton
        rootViewController.present(navVC, animated: true, completion: nil)
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


// MARK: - Show HTML preview

extension ClientCoordinator: InvoiceCoordinatorDelegate {
    
    func shouldShow(invoice: Invoice) {
        delegate?.shouldPreview(invoice)
//        let invoiceVC = UIStoryboard(name: "Invoice", bundle: nil).instantiate(InvoiceViewController.self)
//        let pdfGenerator = PDFGenerator(invoice: invoice)
//        invoiceVC.HTMLContent = pdfGenerator.generate()
//        invoiceVC.title = invoice.number
//        detailsNavigationController.setViewControllers([invoiceVC], animated: false)
    }
}


// MARK: - SplitViewController

extension UISplitViewController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
