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
    
    required init(rootViewController: UISplitViewController, dependencyManager: DependencyManager) {
        self.rootViewController = rootViewController
        self.dependencyManager = dependencyManager
    }
    
    func start() {
        let homeCoordinator = HomeCoordinator(rootViewController: masterNavigationController, dependencyManager: dependencyManager)
        addChildCoordinator(homeCoordinator)
        homeCoordinator.start()
        
        rootViewController.viewControllers = [masterNavigationController, detailsNavigationController]
    }
}
