//
//  DrinkCellViewModel.swift
//  cocktailsProject
//
//  Created by ibaikaa on 21/2/23.
//

import UIKit
import Kingfisher

struct DrinkCellViewModel {
    var drinkName: String
    var imagePath: String 
    
    public func setImageToImageView(imageView: UIImageView) {
        guard let url = URL(string: imagePath) else {
            print("DrinkCellViewModel. Error. URL is nil. \(imagePath)")
            imageView.image = UIImage(systemName: "cup.and.saucer.fill")
            return
        }
        imageView.kf.setImage(with: url)
    }
}
