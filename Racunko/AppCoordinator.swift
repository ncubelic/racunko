//
//  AppCoordinator.swift
//  ZorroTunes
//
//  Created by Nikola on 07/03/2018.
//  Copyright © 2018 Ingemark. All rights reserved.
//

import Foundation
import UIKit

let CurrencyFormatter = NumberFormatter()
let DateTimeFormatter = DateFormatter()
let DateFormat = DateFormatter()
let TimeFormat = DateFormatter()

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
        configureFormatters()
        
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
        let splitCoordinator = SplitViewCoordinator(rootViewController: splitVC, dependencyManager: dependencyManager)
        addChildCoordinator(splitCoordinator)
        splitCoordinator.start()

        rootViewController = splitVC
        splitVC.view.backgroundColor = UIColor(named: "SecondaryDark")
        
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
    
    private func configureFormatters() {
        CurrencyFormatter.numberStyle = .currency
        CurrencyFormatter.locale = Locale(identifier: "hr_HR")
        CurrencyFormatter.currencyCode = "HRK"
        CurrencyFormatter.currencySymbol = "kn"
        CurrencyFormatter.currencyDecimalSeparator = ","
        CurrencyFormatter.currencyGroupingSeparator = "."
        CurrencyFormatter.minimumFractionDigits = 2
        CurrencyFormatter.maximumFractionDigits = 2
        CurrencyFormatter.minimumIntegerDigits = 1
        
        DateTimeFormatter.dateFormat = "dd.MM.yyyy. HH:mm:SS"
        DateFormat.dateFormat = "dd.MM.yyyy."
        TimeFormat.dateFormat = "HH:mm:SS"
    }
}
