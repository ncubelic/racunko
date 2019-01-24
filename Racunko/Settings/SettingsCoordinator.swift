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
    
    let settingsVC: SettingsViewController
    
    required init(rootViewController: UINavigationController, dependencyManager: DependencyManager) {
        self.rootViewController = rootViewController
        self.dependencyManager = dependencyManager
        
        settingsVC = UIStoryboard(name: "Settings", bundle: nil).instantiate(SettingsViewController.self)
    }
    
    func start() {
        let myCompanyData = dependencyManager.coreDataManager.getBusiness().first
        settingsVC.title = "Postavke"
        settingsVC.navigationItem.rightBarButtonItem = settingsVC.editButtonItem
        settingsVC.delegate = self
        settingsVC.items = generateItems(for: myCompanyData)
        rootViewController.setViewControllers([settingsVC], animated: false)
    }
    
    /// Returns tableView datasource with myCompany details if they are saved in app
    private func generateItems(for myCompany: Business?) -> [[Item]] {
        var sections = getStaticData()
        
        guard let myCompany = myCompany else { return sections }
        
        sections[0][0].type.setNewValue(myCompany.name)
        sections[0][1].type.setNewValue(String(myCompany.oib))
        sections[0][2].type.setNewValue(myCompany.address)
        sections[0][3].type.setNewValue(myCompany.zipCity)
        sections[0][4].type.setNewValue(myCompany.phone)
        sections[0][5].type.setNewValue(myCompany.web)
        sections[0][6].type.setNewValue(myCompany.email)
        
        sections[1][0].type.setNewValue(myCompany.iban)
        sections[1][1].type.setNewValue(myCompany.bankName)
        
        sections[2][0].type.setNewValue(myCompany.defaultFootNote)
        sections[2][1].type.setNewValue(myCompany.defaultPaymentType)
        
        return sections
    }
    
    /// Returns array of 'static' items
    private func getStaticData() -> [[Item]] {
        let sections = [
            [
                Item(title: "Naziv obrta", type: ItemType.textField(placeholder: "", text: nil)),
                Item(title: "OIB ili Matični broj", type: ItemType.textField(placeholder: "", text: nil)),
                Item(title: "Adresa sjedišta", type: ItemType.textField(placeholder: "", text: nil)),
                Item(title: "Poštanski broj i mjesto", type: ItemType.textField(placeholder: "", text: nil)),
                Item(title: "Kontakt telefon", type: ItemType.textField(placeholder: "", text: nil)),
                Item(title: "Web stranica", type: ItemType.textField(placeholder: "", text: nil)),
                Item(title: "Email adresa", type: ItemType.textField(placeholder: "", text: nil))
            ],
            [
                Item(title: "IBAN", type: ItemType.textField(placeholder: "Žiro račun obrta", text: nil)),
                Item(title: "Banka", type: ItemType.textField(placeholder: "Naziv banke u kojoj je žiro račun", text: nil))
            ],
            [
                Item(title: "Defaultna napomena u računima (opcionalno)", type: ItemType.textField(placeholder: "Nalazi se u podnožju računa", text: nil)),
                Item(title: "Defaultni način plaćanja", type: ItemType.textField(placeholder: "", text: nil))
            ]
        ]
        
        return sections
    }
    
}

extension SettingsCoordinator: SettingsViewControllerDelegate {
    
    func shouldSave(_ items: [[Item]]) {
        let business = transformToBusiness(from: items)
        dependencyManager.coreDataManager.addBusiness(business)
    }
    
    func showImageUploadAlert(from rect: CGRect?) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Odaberi sliku", style: .default, handler: { _ in
            let imagePickerController = UIImagePickerController()
            imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            imagePickerController.delegate = self
            imagePickerController.modalPresentationStyle = .currentContext
            let popController = imagePickerController.popoverPresentationController
            popController?.delegate = self
            popController?.sourceRect = rect!
            self.rootViewController.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Odustani", style: .cancel, handler: nil))
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = rootViewController.view
            popoverController.sourceRect = CGRect(x: rootViewController.view.bounds.midX, y: rootViewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        rootViewController.present(actionSheet, animated: true, completion: nil)
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

extension SettingsCoordinator: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        // update UI
        settingsVC.setupHeaderImage(chosenImage)
        
        if let imageData = chosenImage.pngData() {
            let path = Bundle.main.bundlePath
            let url = URL(fileURLWithPath: path + "/img/logo.png")
            do {
                try imageData.write(to: url, options: .atomicWrite)
            } catch {
                print("err: \(error)")
            }
        }
        
        rootViewController.dismiss(animated:true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        rootViewController.dismiss(animated: true, completion: nil)
    }
}
