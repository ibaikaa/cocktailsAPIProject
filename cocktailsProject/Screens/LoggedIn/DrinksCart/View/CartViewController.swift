//
//  CartViewController.swift
//  cocktailsProject
//
//  Created by ibaikaa on 23/2/23.
//

import UIKit

class CartViewController: UIViewController {
    @IBOutlet weak var drinksTableView: UITableView!
    
    private func configureDrinksTableView() {
        drinksTableView.dataSource = self
        drinksTableView.delegate = self
        
        drinksTableView.register(UITableViewCell.self, forCellReuseIdentifier: "drink_cell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDrinksTableView()
    }
}

// MARK: UITableViewDataSource
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = drinksTableView.dequeueReusableCell(withIdentifier: "drink_cell", for: indexPath)
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "favoriteDrink_cell")
        cell.textLabel?.font = UIFont(name: "Avenir-Heavy", size: 18)
        cell.textLabel?.text = "Drink name"
        cell.detailTextLabel?.text = "Drink description"
        cell.detailTextLabel?.font = UIFont(name: "Avenir-Light", size: 14)
        cell.detailTextLabel?.textColor = .secondaryLabel
        return cell
    }
}

// MARK: UITableViewDelegate
extension CartViewController: UITableViewDelegate {
    
}
