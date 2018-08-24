//
//  Coordinator.swift
//  ZorroTunes
//
//  Created by Nikola on 07/03/2018.
//  Copyright © 2018 Ingemark. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator: NSObjectProtocol {
    
    var childCoordinators: [Coordinator] { get set }
    var dependencyManager: DependencyManager { get }
    
    func start()
}

extension Coordinator {
    
    func addChildCoordinator(_ childCoordinator: Coordinator) {
        childCoordinators.append(childCoordinator)
    }
    
    func removeChildCoordinator(_ childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== childCoordinator }
    }
}

// MARK: NavigationBar Coordinator
protocol NavigationCoordinator: Coordinator {
    
    var rootViewController: UINavigationController { get set }
    init(rootViewController: UINavigationController, dependencyManager: DependencyManager)
}

// MARK: SplitViewController Coordinator
protocol SplitCoordinator: Coordinator {
    
    var rootViewController: UISplitViewController { get set }
    init(rootViewController: UISplitViewController, dependencyManager: DependencyManager)
}

