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
    
    var restaurant: Restaurant?
    
    private func setup() {
        stylize()
        
        imageView.layer.cornerRadius = 8
        ratingView.layer.cornerRadius = ratingView.frame.size.height / 2
        for subview in blurView.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
        blurView.applyBlurEffect()
    }
    
    func updateFavoriteButton(with restaurant: Restaurant) {
        isFavoriteButton.setImage(UIImage(systemName: DataManager.shared.favoriteRestaurants.contains(restaurant) ? "heart.fill" : "heart"), for: .normal)
    }
    
    func configureCell(with restaurant: Restaurant) {
        setup()
        self.restaurant = restaurant
        
        ratingLabel.text = "\(restaurant.rating)"
        updateFavoriteButton(with: restaurant)
        imageView.image = UIImage(named: restaurant.imageName)
        nameLabel.text = restaurant.name
        dietaryRestrictionOptionsLabel.text = restaurant.dietaryRestrictions.sorted().reduce("") { $0 + $1.rawValue.emoji }
        cuisineLabel.text = restaurant.cuisine.rawValue
        priceLabel.text = restaurant.price.rawValue
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        guard let restaurant = restaurant else { return }
        
        if DataManager.shared.favoriteRestaurants.contains(restaurant), let firstIndex = DataManager.shared.favoriteRestaurants.firstIndex(of: restaurant) {
            var favoriteRestaurants = DataManager.shared.favoriteRestaurants
            
            favoriteRestaurants.remove(at: firstIndex)
            
            DataManager.shared.favoriteRestaurants = favoriteRestaurants
        } else {
            var favoriteRestaurants = DataManager.shared.favoriteRestaurants
            
            favoriteRestaurants.insert(restaurant, at: 0)
            
            DataManager.shared.favoriteRestaurants = favoriteRestaurants
        }
        
        updateFavoriteButton(with: restaurant)
    }
}
