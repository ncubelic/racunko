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
    
    init(window: UIWindow) {
        self.window = window
        window.backgroundColor = .darkGray
        self.rootViewController = UINavigationController()
        self.dependencyManager = DependencyManager(coreDataManager: CoreDataManager())
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
    }
    
    private func showMainFlow() {
        let splitVC = UISplitViewController()
        splitVC.view.backgroundColor = UIColor(named: "SecondaryDark")
        rootViewController = splitVC

        let clientCoordinator = ClientCoordinator(rootViewController: splitVC, dependencyManager: dependencyManager)
        clientCoordinator.start()
        addChildCoordinator(clientCoordinator)
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
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
        navbar.barTintColor = UIColor(named: "SecondaryDark")
        navbar.barStyle = .black
        navbar.tintColor = .white
        navbar.isTranslucent = false
        navbar.shadowImage = UIImage()
        navbar.setBackgroundImage(UIImage(), for: .default)
        navbar.backgroundColor = UIColor(named: "SecondaryDark")
    }
}
