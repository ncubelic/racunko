//
//  DetailsCoordinator.swift
//  Racunko
//
//  Created by Nikola on 22/02/2019.
//  Copyright © 2019 Nikola. All rights reserved.
//

import Foundation
import UIKit

class DetailsCoordinator: NSObject, NavigationCoordinator {
    
    var rootViewController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var dependencyManager: DependencyManager
    
    private var previewVC: PreviewViewController
    
    required init(rootViewController: UINavigationController, dependencyManager: DependencyManager) {
        self.rootViewController = rootViewController
        self.dependencyManager = dependencyManager
        
        previewVC = UIStoryboard(name: "Invoice", bundle: nil).instantiate(PreviewViewController.self)
    }
    
    
    func start() {
        rootViewController.setViewControllers([previewVC], animated: false)
    }
    
    
    
}
