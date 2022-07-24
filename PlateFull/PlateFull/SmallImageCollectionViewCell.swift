//
//  SmallImageCollectionViewCell.swift
//  PlateFull
//
//  Created by Trofim Petyanov on 24.07.2022.
//

import UIKit

class SmallImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    
    func configureCell(with imageName: String) {
        imageView.image = UIImage(named: imageName)
    }
}
