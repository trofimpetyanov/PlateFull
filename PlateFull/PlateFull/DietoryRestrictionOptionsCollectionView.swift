//
//  DietoryRestrictionOptionsCollectionView.swift
//  PlateFull
//
//  Created by Trofim Petyanov on 24.07.2022.
//

import UIKit

class DietoryRestrictionOptionsCollectionView: UICollectionView, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dietoryRestrictionOption", for: indexPath) as! SmallImageCollectionViewCell
        
        cell.configureCell(with: "tanuki")
        
        return cell
    }
}
