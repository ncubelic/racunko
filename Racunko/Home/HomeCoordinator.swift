//
//  SettingsCoordinator.swift
//  Racunko
//
//  Created by Nikola on 21/01/2019.
//  Copyright © 2019 Nikola. All rights reserved.
//

import Foundation
import UIKit

protocol HomeCoordinatorDelegate: class {
    func showClients()
}

class HomeCoordinator: NSObject, NavigationCoordinator {
    
    var rootViewController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var dependencyManager: DependencyManager
    
    weak var delegate: HomeCoordinatorDelegate?
    
    required init(rootViewController: UINavigationController, dependencyManager: DependencyManager) {
        self.rootViewController = rootViewController
        self.dependencyManager = dependencyManager
    }
    
    func start() {
        let homeVC = UIStoryboard(name: "Home", bundle: nil).instantiate(HomeViewController.self)
        homeVC.delegate = self
        homeVC.title = "Računko"
//        rootViewController.navigationItem.largeTitleDisplayMode = .always
        rootViewController.navigationBar.prefersLargeTitles = true
        rootViewController.pushViewController(homeVC, animated: true)
    }
    
}


extension HomeCoordinator: HomeViewControllerDelegate {
    
    func showClientsScreen() {
        delegate?.showClients()
    }
    
    func showInvoicesScreen() {
        print("unimplemented")
    }
    
    func showSettingsScreen() {
        print("unimplemented")
    }
}
