//
//  AddClientViewController.swift
//  Racunko
//
//  Created by Nikola on 24/08/2018.
//  Copyright © 2018 Nikola. All rights reserved.
//

import UIKit

protocol AddClientViewControllerDelegate {
    func cancelAction()
    func save(_ client: Company)
}

enum ItemType {
    case textField(placeholder: String, text: String?)
    case label(text: String)
    case disclosure
    case invoiceItem(item: InvoiceItemModel)
    
    func getValue() -> String? {
        switch self {
        case .textField(_, let string): return string
        case .label(let string): return string
        default: return nil
        }
    }
    
    func getInvoiceItem() -> InvoiceItemModel? {
        switch self {
        case .invoiceItem(let item):
            return item
        default:
            return nil
        }
    }
    
    mutating func setNewValue(_ newValue: String?) {
        switch self {
        case .textField(let placeholder, _):
            self = ItemType.textField(placeholder: placeholder, text: newValue)
        case .label:
            self = ItemType.label(text: newValue ?? "")
        default:
            return
        }
    }
}

struct Item {
    var title: String
    var type: ItemType
}

class AddClientViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: AddClientViewControllerDelegate?
    var client: Company?
    
    var items: [Item] = [
        Item(title: "Naziv firme", type: .textField(placeholder: "Firma d.o.o.", text: nil)),
        Item(title: "Adresa", type: .textField(placeholder: "Ivice Ivića 10", text: nil)),
        Item(title: "Poštanski broj i mjesto", type: .textField(placeholder: "10000 Zagreb", text: nil)),
        Item(title: "OIB", type: .textField(placeholder: "12345678901", text: nil))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        delegate?.cancelAction()
    }
    
    @IBAction func saveAction(_ sender: Any) {
        view.endEditing(true)
        extractCompanyValues(from: items)
        guard let client = client else { return }
        delegate?.save(client)
    }
    
    private func extractCompanyValues(from items: [Item]) {
        guard
            let name = items[0].type.getValue(),
            let oib = Int(items[3].type.getValue() ?? ""),
            let address = items[1].type.getValue(),
            let city = items[2].type.getValue()
            else { return }
        let company = Company(name: name, oib: oib, address: address, zip: 0, city: city)
        client = company
    }
}


// MARK: - UITableView Datasource

extension AddClientViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddClientTableViewCell", for: indexPath) as! AddClientTableViewCell
        cell.setup(with: item)
        cell.textField.delegate = self
        cell.textField.tag = indexPath.row
        return cell
    }
}


// MARK: - UITableView Delegate

extension AddClientViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - UITextField Delegate

extension AddClientViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let itemPositionInTable = textField.tag
        let currentPlaceholder = textField.attributedPlaceholder?.string ?? ""
        items[itemPositionInTable].type = .textField(placeholder: currentPlaceholder, text: textField.text)
    }
}
