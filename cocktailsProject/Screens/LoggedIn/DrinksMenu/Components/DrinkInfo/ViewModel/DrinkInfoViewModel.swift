//
//  DrinkInfoViewModel.swift
//  cocktailsProject
//
//  Created by ibaikaa on 22/2/23.
//

import Foundation
import Kingfisher

final class DrinkInfoViewModel {
    public var drink: Drink!
    
    public func getDrinkToShow(_ data: Drink) {
        self.drink = data
    }
    
    public func setImageToImageView(imageView: UIImageView) {
        guard let url = URL(string: drink.imageURLPath) else {
            print("DrinkCellViewModel. Error. URL is nil. \(drink.imageURLPath)")
            imageView.image = UIImage(systemName: "cup.and.saucer.fill")
            return
        }
        imageView.kf.setImage(with: url)
    }
}
