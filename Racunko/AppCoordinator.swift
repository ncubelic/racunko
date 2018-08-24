//
//  AppCoordinator.swift
//  ZorroTunes
//
//  Created by Nikola on 07/03/2018.
//  Copyright © 2018 Ingemark. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: NSObject, Coordinator {

    var window: UIWindow!
    var rootViewController: UIViewController
    var childCoordinators: [Coordinator] = []
    var dependencyManager: DependencyManager
    
    init(window: UIWindow, rootViewController: UIViewController) {
        self.window = window
        window.backgroundColor = .darkGray
        self.rootViewController = rootViewController
        self.dependencyManager = DependencyManager()
    }

    func start() {
        configureAppearance()
        
        if isLoggedIn() {
            showMainFlow()
        } else {
            showLoginFlow()
        }
    }

    private func isLoggedIn() -> Bool {
        return true
    }
    
    private func showLoginFlow() {
        let vc = UIViewController()
        window.rootViewController = vc
        window.makeKeyAndVisible()
        
//        let loginCoordinator = LoginCoordinator(rootViewController: vc, dependencyManager: dependencyManager)
//        loginCoordinator.delegate = self
//        loginCoordinator.start()
//        addChildCoordinator(loginCoordinator)
    }
    
    private func showMainFlow() {
        let splitVC = UISplitViewController()
        rootViewController = splitVC
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()

//        let ordersCoordinator = OrdersCoordinator(rootViewController: splitVC, dependencyManager: dependencyManager)
//        ordersCoordinator.start()
//        addChildCoordinator(ordersCoordinator)
    }
}


// MARK: - UISplitController Delegate

extension AppCoordinator: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}

//MARK: Configuration

extension AppCoordinator {
    
    private func configureAppearance() {
        let navbar = UINavigationBar.appearance()
        navbar.barStyle = .black
        navbar.tintColor = .white
        navbar.isTranslucent = false
    }
}
