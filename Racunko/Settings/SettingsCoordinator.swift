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
        settingsVC.title = "Postavke"
        settingsVC.navigationItem.rightBarButtonItem = settingsVC.editButtonItem
        settingsVC.delegate = self
        
        let business = dependencyManager.coreDataManager.getBusiness()
        print(business)
        
        rootViewController.setViewControllers([settingsVC], animated: false)
    }
    
    
}

extension SettingsCoordinator: SettingsViewControllerDelegate {
    
    func shouldSave(_ items: [[Item]]) {
        let business = transformToBusiness(from: items)
        dependencyManager.coreDataManager.addBusiness(business)
        
        let bus = dependencyManager.coreDataManager.getBusiness()
        print(bus)
    }
    
    private func transformToBusiness(from items: [[Item]]) -> BusinessModel {
        let businessData = items[0]
        let bankData = items[1]
        let invoiceData = items[2]
        
        var business = BusinessModel()
        business.name = businessData[0].type.getValue()
        business.oib = Int(businessData[1].type.getValue() ?? "0") ?? 0
        business.address = businessData[2].type.getValue()
        business.zipCity = businessData[3].type.getValue()
        business.phone = businessData[4].type.getValue()
        business.web = businessData[5].type.getValue()
        business.email = businessData[6].type.getValue()
        business.iban = bankData[0].type.getValue()
        business.bankName = bankData[1].type.getValue()
        business.defaultFootNote = invoiceData[0].type.getValue()
        business.defaultPaymentType = invoiceData[1].type.getValue()
        return business
    }
}
