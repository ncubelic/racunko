//
//  AddInvoiceViewController.swift
//  Racunko
//
//  Created by Nikola on 31/08/2018.
//  Copyright © 2018 Nikola. All rights reserved.
//

import UIKit

protocol AddInvoiceViewControllerDelegate {
    func cancelAction()
    func save(_ invoice: Invoice)
}

class AddInvoiceViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: AddInvoiceViewControllerDelegate?
    
    var invoice: Invoice?
    
    var items = [
        [
            Item(title: "Datum izdavanja", type: ItemType.textField(placeholder: "dd.MM.yyyy.", text: nil)),
            Item(title: "Vrijeme izdavanja", type: ItemType.textField(placeholder: "HH:mm:SS.", text: nil)),
            Item(title: "Datum isporuke", type: ItemType.textField(placeholder: "dd.MM.yyyy.", text: nil)),
            Item(title: "Broj računa", type: ItemType.textField(placeholder: "#-#-#", text: nil)),
            Item(title: "Datum dospijeća", type: ItemType.textField(placeholder: "dd.MM.yyyy.", text: nil))
        ],
        [
            Item(title: "", type: ItemType.invoiceItem(item: InvoiceItem()))
        ],
        [
            Item(title: "Način plaćanja", type: ItemType.label(text: "Transakcijski račun")),
            Item(title: "Napomena", type: ItemType.label(text: "Plaćanje izvršite prema gore navedenim podacima na račun broj HR1012392130498, pod poziv na broj upišite broj računa")),
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 50
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        
        tableView.register(UINib(nibName: "InvoiceItemTableViewCell", bundle: nil), forCellReuseIdentifier: "InvoiceItemTableViewCell")
        tableView.register(UINib(nibName: "InvoiceItemHeader", bundle: nil), forCellReuseIdentifier: "InvoiceItemHeader")
    }
    
    private func addInvoiceItem() {
        let item = Item(title: "", type: .invoiceItem(item: InvoiceItem()))
        items[1].append(item)
        tableView.reloadData()
    }

    @IBAction func cancelAction(_ sender: Any) {
        delegate?.cancelAction()
    }
    
    @IBAction func saveAction(_ sender: Any) {
        guard let invoice = invoice else { return }
        delegate?.save(invoice)
    }
}


// MARK: - UITableView datasource

extension AddInvoiceViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section][indexPath.row]
        
        switch item.type {
        case .label:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddInvoiceLabelCell", for: indexPath) as! AddInvoiceLabelCell
            cell.setup(with: item)
            return cell
        case .textField:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddInvoiceTextFieldCell", for: indexPath) as! AddInvoiceTextFieldCell
            cell.setup(with: item)
            cell.textField.tag = indexPath.row
            cell.textField.delegate = self
            return cell
        case .invoiceItem(let invoiceItem):
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceItemTableViewCell", for: indexPath) as! InvoiceItemTableViewCell
            cell.setup(with: invoiceItem)
            cell.amountTextField.delegate = self
            cell.amountTextField.tag = 100 + indexPath.row
            cell.priceTextField.delegate = self
            cell.priceTextField.tag = 200 + indexPath.row
            cell.totalAmountTextField.delegate = self
            cell.totalAmountTextField.tag = 300 + indexPath.row
            return cell
        default:
            break
        }

        return UITableViewCell()
    }
}

// MARK: - UITableView delegate

extension AddInvoiceViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            if let header = tableView.dequeueReusableCell(withIdentifier: "InvoiceItemHeader") as? InvoiceItemHeader {
                header.delegate = self
                return header
            }
            return nil
        default:
            return nil
        }
    }
}

extension AddInvoiceViewController: InvoiceItemHeaderDelegate {
    
    func invoiceItemHeaderDidAddItem() {
        addInvoiceItem()
    }
}

extension AddInvoiceViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let row = extractItemRowFromTag(textField.tag)
        let section = extractItemSectionFromTag(textField.tag)
        let item = items[section][row]
        
        switch item.type {
        case .textField(let placeholder, _):
            let newValue = ItemType.textField(placeholder: placeholder, text: textField.text)
            items[0][textField.tag].type = newValue
            
            guard textField.tag < 4, let nextTextField = tableView.cellForRow(at: IndexPath(row: textField.tag + 1, section: 0)) as? AddInvoiceTextFieldCell else {
                view.endEditing(true)
                return true
            }
            nextTextField.textField.becomeFirstResponder()
        case .invoiceItem(let item):
            processInvoiceValue(from: textField, for: item)
        default:
            return true
        }
        return true
    }
    
    private func extractItemRowFromTag(_ tag: Int) -> Int {
        guard tag >= 100 else { return tag }
        return tag % 100
    }
    
    private func extractItemSectionFromTag(_ tag: Int) -> Int {
        guard tag >= 100 else { return 0 }
        return 1
    }
    
    private func getIndexPath(fromTag tag: Int) -> IndexPath {
        let row = extractItemRowFromTag(tag)
        let section = extractItemSectionFromTag(tag)
        return IndexPath(row: row, section: section)
    }
    
    private func processInvoiceValue(from textField: UITextField, for item: InvoiceItem) {
        // get row in which is textfield
        let row = textField.tag % 100
        
        // get column (textfield) number from the row
        let column = (textField.tag - row) / 100
        
        print("\(row) - \(column)")
        
        switch column  {
        case 1:
            guard let text = textField.text, let amount = Int(text) else { return }
            let newValue = InvoiceItem(description: item.description, amount: amount, price: item.price, totalAmount: item.totalAmount, discountPercentage: nil)
            items[1][row].type = ItemType.invoiceItem(item: newValue)
            if let cell = tableView.cellForRow(at: getIndexPath(fromTag: textField.tag)) as? InvoiceItemTableViewCell {
                cell.priceTextField.becomeFirstResponder()
            }
        case 2:
            guard let text = textField.text, let number = currencyFormatter.number(from: text) else { return }
            let newValue = InvoiceItem(description: item.description, amount: item.amount, price: number.doubleValue, totalAmount: item.totalAmount, discountPercentage: nil)
            items[1][row].type = ItemType.invoiceItem(item: newValue)
            if let cell = tableView.cellForRow(at: getIndexPath(fromTag: textField.tag)) as? InvoiceItemTableViewCell {
                cell.totalAmountTextField.becomeFirstResponder()
            }
        case 3:
            guard let text = textField.text, let number = currencyFormatter.number(from: text) else { return }
            let newValue = InvoiceItem(description: item.description, amount: item.amount, price: item.price, totalAmount: number.doubleValue, discountPercentage: nil)
            items[1][row].type = ItemType.invoiceItem(item: newValue)
        default:
            return
        }
    }
}
