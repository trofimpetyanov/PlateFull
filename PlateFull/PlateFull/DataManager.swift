//
//  DataManager.swift
//  PlateFull
//
//  Created by Trofim Petyanov on 24.07.2022.
//

import Foundation

struct DataManager {
    static let shared = DataManager()
    
    var restaurants = [
        Restaurant(name: "Churchill", imageName: "churchill", cuisine: "European", price: .midRange, rating: 4.5, dietaryRestrictions: [.vegetarian, .lactoseFree, .glutenFree], isLastAdded: true, isPopular: false, isCitizensPick: false),
        Restaurant(name: "Benjamin Cafe", imageName: "benjaminCafe", cuisine: "Indian", price: .midRange, rating: 4.5, dietaryRestrictions: [.vegan, .vegetarian, .kosher], isLastAdded: true, isPopular: false, isCitizensPick: false),
        Restaurant(name: "Perchini", imageName: "perchini", cuisine: "Italian", price: .midRange, rating: 4.7, dietaryRestrictions: [.vegan, .vegetarian, .lactoseFree], isLastAdded: false, isPopular: true, isCitizensPick: false),
        Restaurant(name: "Livingstone", imageName: "livingstone", cuisine: "Mixed", price: .expensive, rating: 4.3, dietaryRestrictions: [.glutenFree, .lactoseFree], isLastAdded: false, isPopular: true, isCitizensPick: false),
        Restaurant(name: "Iscra", imageName: "iscra", cuisine: "Italian", price: .midRange, rating: 4.9, dietaryRestrictions: [.vegan, .vegetarian], isLastAdded: false, isPopular: false, isCitizensPick: true),
        Restaurant(name: "Tanuki", imageName: "tanuki", cuisine: "Pan Asian", price: .expensive, rating: 4.3, dietaryRestrictions: [.vegan, .vegetarian, .lactoseFree, .glutenFree], isLastAdded: false, isPopular: false, isCitizensPick: true),
        Restaurant(name: "Surf Coffee", imageName: "surfCoffee", cuisine: "European", price: .cheap, rating: 4.7, dietaryRestrictions: [.vegan, .glutenFree, .lactoseFree], isLastAdded: true, isPopular: false, isCitizensPick: false),
        Restaurant(name: "Coffee Cake", imageName: "coffeeCake", cuisine: "Mixed", price: .cheap, rating: 4.8, dietaryRestrictions: [.lactoseFree, .glutenFree], isLastAdded: false, isPopular: true, isCitizensPick: false),
        Restaurant(name: "Comod", imageName: "comod", cuisine: "Mixed", price: .cheap, rating: 5.0, dietaryRestrictions: [.glutenFree, .lactoseFree, .vegan, .vegetarian], isLastAdded: false, isPopular: false, isCitizensPick: true)
    ]
    
    private init() { }
}
