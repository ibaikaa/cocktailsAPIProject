//
//  AddDrinkViewController.swift
//  cocktailsProject
//
//  Created by ibaikaa on 23/2/23.
//

import UIKit

class AddDrinkViewController: UIViewController {
    private lazy var viewModel: AddDrinkViewModel = { AddDrinkViewModel() }()
    
    private func initViewModel() {
        viewModel.showAlert = { [weak self] title, message in
            DispatchQueue.main.async {
                self?.showAlert(with: title, message: message)
            }
        }
    }
    
    private func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
    }
}

