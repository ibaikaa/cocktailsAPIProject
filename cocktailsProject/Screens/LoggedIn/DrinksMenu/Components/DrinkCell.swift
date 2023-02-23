//
//  DrinkCell.swift
//  cocktailsProject
//
//  Created by ibaikaa on 21/2/23.
//

import UIKit

class DrinkCell: UICollectionViewCell {
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkNameLabel: UILabel!
    
    class var identifier: String { String(describing: self) }
    class var nib: UINib { UINib(nibName: identifier, bundle: nil) }

    override func prepareForReuse() {
        drinkImageView.image = nil
        drinkNameLabel.text = nil
    }
    
    public var cellViewModel: DrinkCellViewModel? {
        didSet {
            drinkNameLabel.text = cellViewModel?.drinkName
            cellViewModel?.setImageToImageView(imageView: drinkImageView)
        }
    }
}
