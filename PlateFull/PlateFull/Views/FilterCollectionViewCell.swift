//
//  FilterCollectionViewCell.swift
//  PlateFull
//
//  Created by Trofim Petyanov on 25.07.2022.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    static let cellID = "filterCell"
    
    @IBOutlet var emojiLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.borderWidth = 2
                layer.shadowColor = UIColor.peach.cgColor
                layer.shadowOpacity = 0.2
            } else {
                layer.borderWidth = 0
                layer.shadowColor = UIColor.black.cgColor
                layer.shadowOpacity = 0.08
            }
        }
    }
    
    private func setup() {
        stylize()
        layer.borderColor = UIColor.darkPeach.cgColor
        layer.cornerRadius = layer.frame.size.height / 2
        layer.masksToBounds = true
    }
    
    func configureCell(with dietaryRestrictionOption: DietaryRestrictionOption) {
        emojiLabel.isHidden = false
        nameLabel.textAlignment = .left
        emojiLabel.text = dietaryRestrictionOption.emoji
        nameLabel.text = dietaryRestrictionOption.name
        
        setup()
    }
    
    func configureCell(with price: Price) {
        emojiLabel.isHidden = true
        nameLabel.textAlignment = .center
        nameLabel.text = price.rawValue
        
        setup()
    }
    
    func configureCell(with cuisine: Cuisine) {
        emojiLabel.isHidden = true
        nameLabel.textAlignment = .center
        nameLabel.text = cuisine.rawValue
        
        setup()
    }
}
