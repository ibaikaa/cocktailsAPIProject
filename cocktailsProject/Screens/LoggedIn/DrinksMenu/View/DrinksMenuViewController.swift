//
//  DrinksMenuViewController.swift
//  cocktailsProject
//
//  Created by ibaikaa on 21/2/23.
//

import UIKit

class DrinksMenuViewController: UIViewController {
    private lazy var viewModel = { DrinksMenuViewModel() }()
    
    private func initViewModel() {
        viewModel.getDrinksWithLetter()
        viewModel.reloadDrinksCollectionView = { [weak self] in
            DispatchQueue.main.async {
                self?.drinksCollectionView.reloadData()
            }
        }
        viewModel.showErrorAlert = { [weak self] error in
            DispatchQueue.main.async {
                self?.showErrorAlert(error: error)
            }
        }
        viewModel.dataFoundWithName = { [weak self] result in
            DispatchQueue.main.async {
                self?.noCocktailsFoundLabel.isHidden = result
            }
        }
    }
    
    private func showErrorAlert(error: String) {
        let errorAlert = UIAlertController(
            title: "Error",
            message: error,
            preferredStyle: .alert)
        errorAlert.addAction(
            .init(title: "OK", style: .default)
        )
        present(errorAlert, animated: true)
    }
    
    @IBOutlet weak var searchDrinkSearchBar: UISearchBar!
    @IBOutlet weak var drinksCollectionView: UICollectionView!
    @IBOutlet weak var noCocktailsFoundLabel: UILabel!
    
    private func configureSearchDrinkSearchBar() {
        searchDrinkSearchBar.delegate = self
    }
    
    private func configureDrinksCollectionView() {
        drinksCollectionView.delegate = self
        drinksCollectionView.dataSource = self
        
        drinksCollectionView.register(
            DrinkCell.nib,
            forCellWithReuseIdentifier: DrinkCell.identifier
        )
    }
    
    private func updateUI () {
        // Customization of UISearchBar
        searchDrinkSearchBar.searchTextField.backgroundColor = .white
        searchDrinkSearchBar.searchTextField.font =  UIFont(name: "Avenir-Book", size: 17)
        searchDrinkSearchBar.searchTextField.tintColor = .black
        searchDrinkSearchBar.searchTextPositionAdjustment = UIOffset(
            horizontal: searchDrinkSearchBar.bounds.size.width / 8,
            vertical: 0
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        configureDrinksCollectionView()
        initViewModel()
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension DrinksMenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let customCellWidth = (drinksCollectionView.bounds.width - 20) / 2
        return CGSize(width: customCellWidth, height: 190)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Check if the user has scrolled to the bottom of the view and it is not
        // searching cocktail process
        let scrollViewContentHeight = drinksCollectionView.contentSize.height
        let scrollOffsetThreshold = scrollViewContentHeight - drinksCollectionView.bounds.size.height
        
        if scrollView.contentOffset.y > scrollOffsetThreshold,
            searchDrinkSearchBar.text!.isEmpty {
            viewModel.getDrinksWithNextLetter()
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let vc = storyboard?
            .instantiateViewController(
                withIdentifier: DrinkInfoViewController.identifier
            ) as? DrinkInfoViewController else { fatalError("no xib found") }
        vc.viewModel.drink = viewModel.filteredDrinks[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: UICollectionViewDataSource
extension DrinksMenuViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int { viewModel.filteredDrinks.count }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = drinksCollectionView.dequeueReusableCell(
            withReuseIdentifier: DrinkCell.identifier,
            for: indexPath
        ) as? DrinkCell else { fatalError("xib does not exists") }
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.cellViewModel = cellVM
        return cell
    }
}

// MARK: UISearchBarDelegate
extension DrinksMenuViewController: UISearchBarDelegate {
    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) { viewModel.getDrinksWithName(searchText) }
}

