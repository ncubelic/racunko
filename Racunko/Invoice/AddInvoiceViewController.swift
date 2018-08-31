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
        ["Datum izdavanja",
        "Vrijeme izdavanja",
        "Datum isporuke",
        "Broj računa",
        "Datum dospijeća"],
        ["Naziv usluge",
        "Količina",
        "Cijena",
        "Popust",
        "Iznos"],
        ["Način plaćanja",
        "Napomena"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddInvoiceTableViewCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.section][indexPath.row]
        return cell
    }
}

// MARK: - UITableView delegate

extension AddInvoiceViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
