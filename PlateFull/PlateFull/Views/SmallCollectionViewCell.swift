//
//  SmallCollectionViewCell.swift
//  PlateFull
//
//  Created by Trofim Petyanov on 24.07.2022.
//

import UIKit

class SmallCollectionViewCell: UICollectionViewCell {
    static let cellId = "smallCell"
    
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var ratingView: UIView!
    @IBOutlet var isFavoriteButton: UIButton!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dietaryRestrictionOptionsLabel: UILabel!
    
    @IBOutlet var cuisineLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    private func setup() {
        stylize()
        
        imageView.layer.cornerRadius = 8
        ratingView.layer.cornerRadius = ratingView.frame.size.height / 2
    }
    
    func configureCell(with restaurant: Restaurant) {
        setup()
        
        ratingLabel.text = "\(restaurant.rating)"
        isFavoriteButton.setImage(UIImage(systemName: restaurant.isFavorite ? "heart.fill" : "heart"), for: .normal)
        imageView.image = UIImage(named: restaurant.imageName)
        nameLabel.text = restaurant.name
        dietaryRestrictionOptionsLabel.text = restaurant.dietaryRestrictions.sorted().reduce("") {$0 + $1.rawValue.emoji }
        cuisineLabel.text = restaurant.cuisine
        priceLabel.text = restaurant.price.rawValue
    }
}
