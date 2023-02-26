//
//  AddDrinkViewModel.swift
//  cocktailsProject
//
//  Created by ibaikaa on 26/2/23.
//

import Foundation

final class AddDrinkViewModel {
    private var db: DatabaseManager
    
    init() { self.db = DatabaseManager.shared }
    
    public var showAlert: ((String, String) -> Void)?
    
    public func uploadNewDrinkToDatabase(
        name: String?,
        description: String?,
        price: String?
    ) {
        guard
            let name = name, !name.isEmpty,
            let description = description, !description.isEmpty,
            let price = price, !price.isEmpty, let priceDouble = Double(price)
        else {
            showAlert?("Error", "All of the fields must be filled!\nAnd price field must be a number!")
            return
        }
        
        let data: [String:Any] = [
            "Name": name,
            "Description": description,
            "Price": priceDouble
        ]
        
        db.set(
            to: DatabaseCollection.cocktails,
            document: DatabaseDocument.postRequest,
            with: data
        ) { [weak self] result in
            switch result {
            case .success(()): self?.showAlert?("Success!", "Succesfully updated the database with new data.")
            case .failure(let error): self?.showAlert?("Error", error.localizedDescription)
            }
        }
    }
}
