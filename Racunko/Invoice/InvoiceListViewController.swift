//
//  InvoiceListViewController.swift
//  Racunko
//
//  Created by Nikola on 24/08/2018.
//  Copyright © 2018 Nikola. All rights reserved.
//

import UIKit

protocol InvoiceListViewControllerDelegate {
    func addNewInvoice(for company: Company)
}

class InvoiceListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var delegate: InvoiceListViewControllerDelegate?
    var currentCompany: Company?
    
    var items: [InvoiceModel] = [
//        InvoiceModel(number: "1-1-1", createdAt: Date(), amount: 14960, date: Date(), company: Company(name: "Ingemark d.o.o.", oib: 1234123, address: "Vukovarska 269d", zip: 10000, city: "Zagreb")),
//        InvoiceModel(number: "1-1-1", createdAt: Date(), amount: 14960, date: Date(), company: Company(name: "Ingemark d.o.o.", oib: 1234123, address: "Vukovarska 269d", zip: 10000, city: "Zagreb")),
//        InvoiceModel(number: "1-1-1", createdAt: Date(), amount: 14960, date: Date(), company: Company(name: "Ingemark d.o.o.", oib: 1234123, address: "Vukovarska 269d", zip: 10000, city: "Zagreb"))
    ]
    
    var items2: [Invoice] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addNewInvoiceAction(_ sender: Any) {
        guard let company = currentCompany else { return }
        delegate?.addNewInvoice(for: company)
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
