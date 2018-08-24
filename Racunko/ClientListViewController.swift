//
//  ClientListViewController.swift
//  Racunko
//
//  Created by Nikola on 24/08/2018.
//  Copyright © 2018 Nikola. All rights reserved.
//

import UIKit

protocol ClientListViewControllerDelegate {
    func didSelectCompany(_ company: Company)
    func addNewClient()
}

class ClientListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var delegate: ClientListViewControllerDelegate?
    
    var items: [Company] = [
        Company(name: "Ingemark d.o.o.", oib: 1234123, address: "Vukovarska 269d", zip: 10000, city: "Zagreb"),
        Company(name: "Ingemark d.o.o.", oib: 1234123, address: "Vukovarska 269d", zip: 10000, city: "Zagreb"),
        Company(name: "Ingemark d.o.o.", oib: 1234123, address: "Vukovarska 269d", zip: 10000, city: "Zagreb"),
        Company(name: "Ingemark d.o.o.", oib: 1234123, address: "Vukovarska 269d", zip: 10000, city: "Zagreb")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .always
    }
    
    @IBAction func addClientAction(_ sender: Any) {
        delegate?.addNewClient()
    }

}

extension ClientListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClientTableViewCell", for: indexPath) as! ClientTableViewCell
        cell.setup(with: item)
        return cell
    }
}


extension ClientListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let company = items[indexPath.row]
        delegate?.didSelectCompany(company)
    }
}
