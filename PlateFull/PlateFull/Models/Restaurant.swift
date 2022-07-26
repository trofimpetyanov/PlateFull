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
    
    let cuisine: Cuisine
    let price: Price
    let rating: Double
    
    let dietaryRestrictions: [DietaryRestrictionOptions]
    
    let isLastAdded: Bool
    let isPopular: Bool
    let isCitizensPick: Bool
    
    let menuLink: String
    
    let latitude: Double
    let longitude: Double
}

extension Restaurant: Codable { }

extension Restaurant: Hashable {
    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
