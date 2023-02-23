//
//  FavoriteDrinksViewController.swift
//  cocktailsProject
//
//  Created by ibaikaa on 23/2/23.
//

import UIKit

class FavoriteDrinksViewController: UIViewController {
    @IBOutlet weak var favoriteDrinksTableView: UITableView!
    
    private func configureFavoriteDrinksTableView() {
        favoriteDrinksTableView.dataSource = self
        favoriteDrinksTableView.delegate = self
        
        favoriteDrinksTableView.register(UITableViewCell.self, forCellReuseIdentifier: "favoriteDrink_cell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFavoriteDrinksTableView()
    }
}

// MARK: UITableViewDataSource
extension FavoriteDrinksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = favoriteDrinksTableView.dequeueReusableCell(withIdentifier: "favoriteDrink_cell", for: indexPath)
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
extension FavoriteDrinksViewController: UITableViewDelegate {
    
}
