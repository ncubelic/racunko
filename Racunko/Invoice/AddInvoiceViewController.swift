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
        
        tableView.register(UINib(nibName: "InvoiceItemTableViewCell", bundle: nil), forCellReuseIdentifier: "InvoiceItemTableViewCell")
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
            return cell
        case .invoiceItem(let invoiceItem):
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceItemTableViewCell", for: indexPath) as! InvoiceItemTableViewCell
            cell.setup(with: invoiceItem)
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
}
