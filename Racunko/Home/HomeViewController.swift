//
//  HomeViewController.swift
//  Racunko
//
//  Created by Nikola on 21/01/2019.
//  Copyright © 2019 Nikola. All rights reserved.
//

import UIKit

protocol HomeViewControllerDelegate: class {
    func showClientsScreen()
    func showInvoicesScreen()
    func showSettingsScreen()
}

class HomeViewController: UIViewController {

    weak var delegate: HomeViewControllerDelegate?
    
    let items: [[Item]] = [
        [
            Item(title: "Klijenti", type: ItemType.disclosure),
            Item(title: "Računi", type: ItemType.disclosure),
            
        ],
        [
            Item(title: "Postavke", type: ItemType.disclosure)
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
    }

}


extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section][indexPath.row]
        
        switch item.type {
        case .disclosure:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = item.title
            return cell
        default:
            return UITableViewCell()
        }
    }
}


extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: delegate?.showClientsScreen()
            case 1: delegate?.showInvoicesScreen()
            default: break
            }
        default: delegate?.showSettingsScreen()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return ""
        case 1:
            return "Podaci o obrtu"
        default:
            return ""
        }
    }
}
