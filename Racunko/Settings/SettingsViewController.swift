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
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    weak var delegate: SettingsViewControllerDelegate?
    
    var items: [[Item]] = []
    
    var rect: CGRect?
    
    private var logoHeader: LogoHeader?
    private var logoImage: UIImage?
    
    var keyboardObserver: NSObjectProtocol? = nil
    
    deinit {
        if let keyboardObserver = keyboardObserver {
            NotificationCenter.default.removeObserver(keyboardObserver)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TextFieldCell", bundle: nil), forCellReuseIdentifier: "TextFieldCell")
        tableView.register(UINib(nibName: "LogoHeader", bundle: nil), forCellReuseIdentifier: "LogoHeader")
//        tableView.allowsSelectionDuringEditing = true
        
        // keyboard observer
        let _ = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        view.addGestureRecognizer(gestureRecognizer)
        
        keyboardObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: nil) { notification in
            
            if let userInfo = notification.userInfo,
                let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
                let endFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
                let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber {
                
                self.tableViewBottomConstraint.constant = UIScreen.main.bounds.height - endFrameValue.cgRectValue.minY
                
                UIView.animate(withDuration: durationValue.doubleValue, delay: 0, options: UIView.AnimationOptions(rawValue: UInt(curve.intValue << 16)), animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupHeaderImage(_ image: UIImage) {
        self.logoImage = image
        tableView?.reloadData()
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
        firstCell?.textField.isEnabled = true
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditing {
            guard let cell = tableView.cellForRow(at: indexPath) as? TextFieldCell else { return }
            cell.textField.isEnabled = true
            cell.textField.becomeFirstResponder()
        }
    }
    
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = .gradientDark2
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.backgroundColor = .secondaryDark
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
        textField.isEnabled = true
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
