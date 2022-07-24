//
//  Restaurant.swift
//  PlateFull
//
//  Created by Trofim Petyanov on 24.07.2022.
//

import Foundation

struct Restaurant {
    let name: String
    let imageName: String
    
    let cuisine: String
    let price: Price
    let rating: Double
    
    let dietaryRestrictions: [DietaryRestrictionOptions]
    
    let isLastAdded: Bool
    let isPopular: Bool
    let isCitizensPick: Bool
    
    var isFavorite: Bool = false
    var isVisited: Bool = false
}

extension Restaurant: Hashable {
    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
