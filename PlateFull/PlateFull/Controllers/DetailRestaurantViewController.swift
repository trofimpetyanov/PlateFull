//
//  DetailRestaurantViewController.swift
//  PlateFull
//
//  Created by Trofim Petyanov on 24.07.2022.
//

import UIKit

class DetailRestaurantViewController: UIViewController {
    
    @IBOutlet var favoriteButton: UIBarButtonItem!
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var detailView: UIView!
    @IBOutlet var restaurantNameLabel: UILabel!
    @IBOutlet var cuisineTypeLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    
    @IBOutlet var collectionView: UICollectionView!
    
    //MARK: – Properties
    var restaurant: Restaurant?
    
    //MARK: – Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: – Helpers
    private func setupUI() {
        detailView.layer.cornerRadius = 32
        detailView.layer.shadowColor = UIColor.black.cgColor
        detailView.layer.shadowOffset = CGSize(width: 0, height: 0)
        detailView.layer.shadowRadius = 6.0
        detailView.layer.shadowOpacity = 0.1
        detailView.layer.masksToBounds = false
        detailView.layer.shadowPath = UIBezierPath(roundedRect: CGRect(origin: detailView.bounds.origin, size: CGSize(width: detailView.bounds.size.width, height: detailView.bounds.size.height - 200)), cornerRadius: detailView.layer.cornerRadius).cgPath
        
        imageView.layer.cornerRadius = 16
    }
    
    private func setup() {
        setupUI()
        
        if let restaurant = restaurant {
            title = restaurant.name
            favoriteButton.image = UIImage(systemName: DataManager.shared.favoriteRestaurants.contains(restaurant) ? "heart.fill" : "heart")
            imageView.image = UIImage(named: restaurant.imageName)
            restaurantNameLabel.text = restaurant.name
            cuisineTypeLabel.text = restaurant.cuisine.rawValue
            priceLabel.text = restaurant.price.rawValue
            ratingLabel.text = "Rating: \(restaurant.rating)"
        }
        
        collectionView.collectionViewLayout = createLayout()
    }
    
    //MARK: – Actions
    @IBAction func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        guard let restaurant = restaurant else { return }
        
        if DataManager.shared.favoriteRestaurants.contains(restaurant), let firstIndex = DataManager.shared.favoriteRestaurants.firstIndex(of: restaurant) {
            var favoriteRestaurants = DataManager.shared.favoriteRestaurants
            
            favoriteRestaurants.remove(at: firstIndex)
            
            DataManager.shared.favoriteRestaurants = favoriteRestaurants
            favoriteButton.image = UIImage(systemName: "heart")
        } else {
            var favoriteRestaurants = DataManager.shared.favoriteRestaurants
            
            favoriteRestaurants.insert(restaurant, at: 0)
            
            DataManager.shared.favoriteRestaurants = favoriteRestaurants
            favoriteButton.image = UIImage(systemName: "heart.fill")
        }
    }
    
    @IBAction func viewMenuButtonTapped(_ sender: UIButton) {
        if let restaurant = restaurant, let url = URL(string: restaurant.menuLink) {
            UIApplication.shared.open(url)
        }
    }
    
    //MARK: – Layout
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let spacing: CGFloat = 8
        let padding: CGFloat = 16
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let itemSize = NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(0.5),
				heightDimension: .fractionalHeight(1)
			)
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1),
				heightDimension: .absolute(40)
			)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
            group.interItemSpacing = .fixed(spacing)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(
				top: padding,
				leading: spacing,
				bottom: padding,
				trailing: spacing
			)
            section.interGroupSpacing = spacing
            
            return section
        }
        
        return layout
    }
}

// MARK: – Collection View Data Source
extension DetailRestaurantViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let restaurant = restaurant {
            return restaurant.dietaryRestrictions.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiLabelCollectionViewCell.cellID, for: indexPath) as? EmojiLabelCollectionViewCell, let restaurant = restaurant else { return UICollectionViewCell() }
        
        cell.configureCell(with: restaurant.dietaryRestrictions[indexPath.item].rawValue)
        
        return cell
    }
}
