//
//  DietaryRestrictionOption.swift
//  PlateFull
//
//  Created by Trofim Petyanov on 24.07.2022.
//

import Foundation

struct DietaryRestrictionOption: Codable {
    let name: String
    let emoji: String
}

extension DietaryRestrictionOption: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(emoji)
    }
}
