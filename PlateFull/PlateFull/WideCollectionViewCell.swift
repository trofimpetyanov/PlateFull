//
//  WideCollectionViewCell.swift
//  PlateFull
//
//  Created by Trofim Petyanov on 24.07.2022.
//

import UIKit

class WideCollectionViewCell: UICollectionViewCell {
    static let cellId = "wideCell"
    
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var ratingView: UIView!
    @IBOutlet var isFavoriteButton: UIButton!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var blurView: UIView!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dietaryRestrictionOptionsLabel: UILabel!
    
    @IBOutlet var cuisineLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    private func setup() {
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 8.0
        layer.shadowOpacity = 0.12
        layer.masksToBounds = false
        layer.cornerRadius = 16
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        
        imageView.layer.cornerRadius = 8
        ratingView.layer.cornerRadius = ratingView.frame.size.height / 2
        blurView.applyBlurEffect()
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
