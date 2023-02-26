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
        viewModel.showAlert = { [weak self] title, message, completion in
            DispatchQueue.main.async {
                self?.showAlert(with: title, message: message, completion: completion)
            }
        }
        
        viewModel.resetTextFields = { [weak self] in
            DispatchQueue.main.async {
                self?.resetTextFields()
            }
        }
    }
    
    private func showAlert(with title: String, message: String, completion: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: completion)
    }
    
    private func resetTextFields() {
        [nameTextField, descriptionTextField, priceTextField].forEach { $0.text = "" }
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBAction func createDrink(_ sender: Any) {
        viewModel.uploadNewDrinkToDatabase(
            name: nameTextField.text,
            description: descriptionTextField.text,
            price: priceTextField.text
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
    }
}

