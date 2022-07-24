//
//  Price.swift
//  PlateFull
//
//  Created by Trofim Petyanov on 24.07.2022.
//

import Foundation

enum Price: String, CaseIterable, Codable {
    case cheap = "$-$$"
    case midRange = "$$-$$$"
    case expensive = "$$$-$$$$"
}
