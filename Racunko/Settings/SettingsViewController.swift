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
    func showImageUploadAlert(from rect: CGRect?)
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: SettingsViewControllerDelegate?
    
    var items: [[Item]] = []
    
    var rect: CGRect?
    
    private var logoHeader: LogoHeader?
    private var logoImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TextFieldCell", bundle: nil), forCellReuseIdentifier: "TextFieldCell")
        tableView.register(UINib(nibName: "LogoHeader", bundle: nil), forCellReuseIdentifier: "LogoHeader")
    }
    
    func setupHeaderImage(_ image: UIImage) {
        self.logoImage = image
        tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            guard let header = tableView.dequeueReusableCell(withIdentifier: "LogoHeader") as? LogoHeader else { return nil }
            logoHeader = header
            header.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showImageUploadAlert)))
            if let image = logoImage {
                header.setup(with: image)
            }
            self.rect = header.bounds
            return header
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0: return 130
        default: return 30
        }
    }
    
    @objc func showImageUploadAlert() {
        delegate?.showImageUploadAlert(from: rect)
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
