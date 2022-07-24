//
//  ImageLabelCollectionViewCell.swift
//  PlateFull
//
//  Created by Trofim Petyanov on 24.07.2022.
//

import UIKit

class EmojiLabelCollectionViewCell: UICollectionViewCell {
    static let cellID = "emojiLabelCell"
    
    @IBOutlet var emojiLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    func configureCell(with dietaryRestrictionOption: DietaryRestrictionOption) {
        emojiLabel.text = dietaryRestrictionOption.emoji
        nameLabel.text = dietaryRestrictionOption.name
        
        stylize()
        layer.cornerRadius = 20
    }
}
