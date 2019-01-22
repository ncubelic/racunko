//
//  InvoiceListViewController.swift
//  Racunko
//
//  Created by Nikola on 24/08/2018.
//  Copyright © 2018 Nikola. All rights reserved.
//

import UIKit

protocol InvoiceListViewControllerDelegate {
    func addNewInvoice(for client: Client)
    func removeInvoice(_ invoice: Invoice)
    func didSelect(_ invoice: Invoice)
}

class InvoiceListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var delegate: InvoiceListViewControllerDelegate?
    var currentCompany: Company?
    var currentClient: Client?
    
    var items: [InvoiceModel] = []
    
    var items2: [Invoice] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addNewInvoiceAction(_ sender: Any) {
        guard let client = currentClient else { return }
        delegate?.addNewInvoice(for: client)
    }
}


extension InvoiceListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items2[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceTableViewCell", for: indexPath) as! InvoiceTableViewCell
        cell.setup(with: item)
        return cell
    }
}

extension InvoiceListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let invoice = items2[indexPath.row]
        delegate?.didSelect(invoice)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            confirmDeletion {
                self.deleteInvoice(at: indexPath)
            }
        }
    }
    
    private func deleteInvoice(at indexPath: IndexPath) {
        let invoice = items2[indexPath.row]
        delegate?.removeInvoice(invoice)
        items2.remove(at: indexPath.row)
        
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    private func confirmDeletion(handler: @escaping () -> ()) {
        let alert = UIAlertController(title: "Želiš li izbrisati?", message: "Jesi li siguran da želiš izbrisati", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Odustani", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Izbriši", style: .destructive) { _ in handler() })
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(alert, animated: true, completion: nil)
    }
}
