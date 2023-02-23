//
//  DrinksMenuViewModel.swift
//  cocktailsProject
//
//  Created by ibaikaa on 21/2/23.
//

import Foundation

final class DrinksMenuViewModel {
    enum ArrivedData {
        case drinksByLetter
        case drinksByName
    }
    private var networkManager: NetworkManager
    
    private var currentLetter: String
    
    private var currentLetterUnicodeValue: UInt32 = 97 {
        didSet {
            let scalar = UnicodeScalar(currentLetterUnicodeValue)!
            currentLetter = String(scalar)
        }
    }

    init () {
        self.networkManager = NetworkManager.shared
        currentLetter = "a"
    }
    
    public var reloadDrinksCollectionView: (() -> Void)?
    public var showErrorAlert: ((String) -> Void)?
    public var dataFoundWithName:((Bool) -> Void)?
    
    public var drinks = [Drink]() {
        didSet {
            filteredDrinks = drinks
        }
    }
    
    private var drinkCellViewModels = [DrinkCellViewModel]() {
        didSet {
            filteredDrinksCellViewModels = drinkCellViewModels
        }
    }
    
    public var filteredDrinks = [Drink]() {
        didSet {
            dataFoundWithName?(!filteredDrinks.isEmpty)
        }
    }
    
    private var filteredDrinksCellViewModels = [DrinkCellViewModel]() {
        didSet {
            reloadDrinksCollectionView?()
        }
    }
    
    public func getDrinksWithLetter() {
        Task {
            do {
                let model = try await networkManager.fetchCocktailsWithLetter(currentLetter)
                fetchData(
                    drinks: model.drinks ?? [],
                    dataType: .drinksByLetter
                )
            } catch {
                showErrorAlert?(error.localizedDescription)
            }
        }
    }
    
    private func fetchData(drinks: [Drink], dataType: ArrivedData) {
        var viewModels = [DrinkCellViewModel]()
        for drink in drinks {
            viewModels.append(createCellModel(drink: drink))
        }
        switch dataType {
        case .drinksByLetter:
            self.drinks.append(contentsOf: drinks)
            drinkCellViewModels.append(contentsOf: viewModels)
        case .drinksByName:
            filteredDrinks = drinks
            filteredDrinksCellViewModels = viewModels
        }
    }
    
    private func createCellModel(drink: Drink) -> DrinkCellViewModel {
        let name = drink.name
        let imagePath = drink.imageURLPath
        return DrinkCellViewModel(drinkName: name, imagePath: imagePath)
    }
    
    public func getCellViewModel(at indexPath: IndexPath) -> DrinkCellViewModel {
        filteredDrinksCellViewModels[indexPath.row]
    }
    
    public func getDrinksWithNextLetter() {
        currentLetterUnicodeValue += 1
        getDrinksWithLetter()
    }
    
    public func getDrinksWithName(_ name: String) {
        guard !name.isEmpty else {
            filteredDrinks = drinks
            filteredDrinksCellViewModels = drinkCellViewModels
            return
        }
        Task {
            do {
                let model = try await networkManager.fetchCocktailsWithName(name)
                fetchData(
                    drinks: model.drinks ?? [],
                    dataType: .drinksByName
                )
            } catch {
                showErrorAlert?(error.localizedDescription)
            }
        }
    }
    
}
