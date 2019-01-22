//
//  SettingsCoordinator.swift
//  Racunko
//
//  Created by Nikola on 22/01/2019.
//  Copyright © 2019 Nikola. All rights reserved.
//

import Foundation
import UIKit

class SettingsCoordinator: NSObject, NavigationCoordinator {

    var rootViewController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var dependencyManager: DependencyManager
    
    required init(rootViewController: UINavigationController, dependencyManager: DependencyManager) {
        self.rootViewController = rootViewController
        self.dependencyManager = dependencyManager
    }
    
    
    func start() {
        let settingsVC = UIStoryboard(name: "Settings", bundle: nil).instantiate(SettingsViewController.self)
        rootViewController.setViewControllers([settingsVC], animated: false)
    }
    
    
}
