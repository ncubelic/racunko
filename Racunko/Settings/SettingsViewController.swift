//
//  SettingsViewController.swift
//  Racunko
//
//  Created by Nikola on 22/01/2019.
//  Copyright © 2019 Nikola. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var items: [[Item]] = [
        [
            Item(title: "Naziv obrta", type: ItemType.textField(placeholder: "Pojavljivat će se na računima", text: nil)),
            Item(title: "OIB ili Matični broj", type: ItemType.textField(placeholder: "Pojavljivat će se na računima", text: nil)),
            Item(title: "Adresa sjedišta", type: ItemType.textField(placeholder: "", text: nil)),
            Item(title: "Poštanski broj i mjesto", type: ItemType.textField(placeholder: "", text: nil)),
            Item(title: "Kontakt telefon", type: ItemType.textField(placeholder: "", text: nil)),
            Item(title: "Web stranica", type: ItemType.textField(placeholder: "www.lioncode.hr", text: nil)),
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TextFieldCell", bundle: nil), forCellReuseIdentifier: "TextFieldCell")
    }


}

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section][indexPath.row]
        
        switch item.type {
        case .textField:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
            cell.setup(with: item)
            cell.textField.tag = indexPath.row
//            cell.textField.delegate = self
            return cell
        default: return UITableViewCell()
        }
    }
    
}


extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Podaci o obrtu"
        case 1: return "Podaci o bankovnom računu"
        case 2: return "Detalji računa"
        default: return nil
        }
    }
}
