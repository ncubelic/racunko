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

class AddClientViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: AddClientViewControllerDelegate?
    var client: Company?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        delegate?.cancelAction()
    }
    
    @IBAction func saveAction(_ sender: Any) {
        guard let client = client else { return }
        delegate?.save(client)
    }
}


// MARK: - UITableView Datasource

extension AddClientViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddCompanyTableViewCell", for: indexPath)
        return cell
    }
}


// MARK: - UITableView Delegate

extension AddClientViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
