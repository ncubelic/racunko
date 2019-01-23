//
//  SettingsViewController.swift
//  Racunko
//
//  Created by Nikola on 22/01/2019.
//  Copyright © 2019 Nikola. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: class {
    func shouldSave(_ items: [[Item]])
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: SettingsViewControllerDelegate?
    
    var items: [[Item]] = [
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TextFieldCell", bundle: nil), forCellReuseIdentifier: "TextFieldCell")
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if isEditing {
            enableEditing()
        } else {
            view.endEditing(true)
            delegate?.shouldSave(items)
        }
    }
    
    private func enableEditing() {
        let firstCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TextFieldCell
        firstCell?.textField.becomeFirstResponder()
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
            cell.textField.delegate = self
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


extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let editedIndexPath = getIndexPath(textField) else { return }
        guard let value = textField.text else { return }
        
        items[editedIndexPath.section][editedIndexPath.row].type.setNewValue(value)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let currentIndexPath = getIndexPath(textField) else { return true }
        
        let nextTextField = getNextCell(after: currentIndexPath)
        
        guard let textField = nextTextField?.textField else {
            view.endEditing(true)
            return true
        }
        textField.becomeFirstResponder()
        return true
    }
    
    func getNextCell(after indexPath: IndexPath) -> TextFieldCell? {
        let nextIndexPathRow = indexPath.adding(.row, 1)
        
        guard let nextCellInCurrentSection = tableView.cellForRow(at: nextIndexPathRow) as? TextFieldCell else {
            // return first textField in next section
            return tableView.cellForRow(at: IndexPath(row: 0, section: indexPath.section + 1)) as? TextFieldCell
        }
        return nextCellInCurrentSection
    }
    
    func getIndexPath(_ textField: UITextField) -> IndexPath? {
        let pointInTableView = textField.convert(textField.bounds.origin, to: tableView)
        return tableView.indexPathForRow(at: pointInTableView)
    }
}


enum IndexPathType {
    case row
    case section
}

extension IndexPath {
    
    func adding(_ type: IndexPathType, _ value: Int) -> IndexPath {
        switch type {
        case .row:
            return IndexPath(row: self.row + 1, section: self.section)
        case .section:
            return IndexPath(row: self.row, section: self.section + 1)
        }
    }
}
