//
//  InvoiceListViewController.swift
//  Racunko
//
//  Created by Nikola on 24/08/2018.
//  Copyright © 2018 Nikola. All rights reserved.
//

import UIKit

class InvoiceListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var items: [Invoice] = [
        Invoice(number: "1-1-1", createdAt: Date(), amount: 14960, date: Date(), company: Company(name: "Ingemark d.o.o.", oib: 1234123, address: "Vukovarska 269d", zip: 10000, city: "Zagreb")),
        Invoice(number: "1-1-1", createdAt: Date(), amount: 14960, date: Date(), company: Company(name: "Ingemark d.o.o.", oib: 1234123, address: "Vukovarska 269d", zip: 10000, city: "Zagreb")),
        Invoice(number: "1-1-1", createdAt: Date(), amount: 14960, date: Date(), company: Company(name: "Ingemark d.o.o.", oib: 1234123, address: "Vukovarska 269d", zip: 10000, city: "Zagreb"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


extension InvoiceListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceTableViewCell", for: indexPath) as! InvoiceTableViewCell
        cell.setup(with: item)
        return cell
    }
}
