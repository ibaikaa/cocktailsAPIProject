//
//  DrinkInfoViewController.swift
//  cocktailsProject
//
//  Created by ibaikaa on 22/2/23.
//

import UIKit
import PaddingLabel
import Cosmos
import SnapKit

class DrinkInfoViewController: UIViewController {
    public lazy var viewModel = { DrinkInfoViewModel() }()
    
    private func initViewModel() {
        viewModel.setImageToImageView(imageView: drinkImageView)
        drinkNameLabel.text = viewModel.drink.name
        drinkDescriptionLabel.text = viewModel.drink.description
    }
    
    class var identifier: String { String(describing: self) }
    class var nib: UINib { UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkNameLabel: PaddingLabel!
    @IBOutlet weak var likeDrinkButton: UIButton!
    @IBOutlet weak var drinkDescriptionLabel: UILabel!
    @IBOutlet weak var totalDrinksChosen: UILabel!
    @IBOutlet weak var addDrinkToCartButton: UIButton!
    @IBOutlet weak var drinkStarsRating: CosmosView!
    @IBOutlet weak var latestUserRatedNameLabel: UILabel!
    @IBOutlet weak var latestUserRatedCommentLabel: UILabel!
    @IBOutlet weak var penultimateUserRatedNameLabel: UILabel!
    @IBOutlet weak var penultimateUserRatedCommentLabel: UILabel!
    
    private lazy var customBackBarButton: UIBarButtonItem = {
        // Configurating the custom UIButton
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "backButton")!, for: .normal)
        backButton.tintColor = .white
        backButton.backgroundColor = .clear
        backButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        backButton.addTarget(self, action: #selector(returnToMainPage), for: .touchUpInside)
        
        //Creating the UIBarButtomItem via the custom backButton
        let backBarButton = UIBarButtonItem(customView: backButton)
        return backBarButton
    }()
    
    @objc
    func returnToMainPage() {
        drinkImageView.image = nil
        navigationController?.popToRootViewController(animated: false)
        navigationItem.leftBarButtonItem = customBackBarButton
    }
    
    
    @IBAction func rateDrinkButtonTapped(_ sender: Any) {
        
    }
    
    private func showRateAlert() {
        let alert = UIAlertController(
            title: "Rate drink",
            message: "Please, fill all the fields to rate this cocktail!",
            preferredStyle: .alert
        )
    }
    
    private func updateUI() {
        likeDrinkButton.cornerRadius = likeDrinkButton.bounds.width / 2
        addDrinkToCartButton.cornerRadius = addDrinkToCartButton.bounds.width / 2
        navigationController?.navigationBar.backgroundColor = .clear
        navigationItem.leftBarButtonItem = customBackBarButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        initViewModel()
    }
}
