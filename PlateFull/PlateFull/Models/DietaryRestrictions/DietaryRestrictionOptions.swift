//
//  DietaryRestriction.swift
//  PlateFull
//
//  Created by Trofim Petyanov on 24.07.2022.
//

import Foundation

enum DietaryRestrictionOptions: CaseIterable, Codable {
    case lactoseFree
    case glutenFree
    case vegetarian
    case vegan
    case kosher
}

extension DietaryRestrictionOptions: RawRepresentable {
    typealias RawValue = DietaryRestrictionOption
    
    init?(rawValue: DietaryRestrictionOption) { return nil }
    
    var rawValue: RawValue {
        switch self {
        case .lactoseFree:
            return DietaryRestrictionOption(name: "Lactose Free", emoji: "🥛")
        case .glutenFree:
            return DietaryRestrictionOption(name: "Gluten Free", emoji: "🥖")
        case .vegetarian:
            return DietaryRestrictionOption(name: "Vegetarian", emoji: "🥦")
        case .vegan:
            return DietaryRestrictionOption(name: "Vegan", emoji: "🌱")
        case .kosher:
            return DietaryRestrictionOption(name: "Kosher", emoji: "🍚")
        }
    }
}

extension DietaryRestrictionOptions: Comparable {
    static func < (lhs: DietaryRestrictionOptions, rhs: DietaryRestrictionOptions) -> Bool {
        return lhs.rawValue.name < rhs.rawValue.name
    }
}
