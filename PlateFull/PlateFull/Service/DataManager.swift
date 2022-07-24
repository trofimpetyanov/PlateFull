//
//  DataManager.swift
//  PlateFull
//
//  Created by Trofim Petyanov on 24.07.2022.
//

import Foundation

struct DataManager {
    //MARK: – Shared
    static var shared = DataManager()
    private let defaults = UserDefaults.standard
    
    //MARK: – Data
    var restaurants = [
        Restaurant(name: "Churchill", imageName: "churchill", cuisine: .european, price: .midRange, rating: 4.5, dietaryRestrictions: [.vegetarian, .lactoseFree, .glutenFree], isLastAdded: true, isPopular: false, isCitizensPick: false, menuLink: "https://churchill.perfecto-group.ru/wp-content/uploads/2022/06/churchill-menu-06-2022.pdf", latitude: 53.209832, longitude: 50.138696),
        Restaurant(name: "Benjamin Cafe", imageName: "benjaminCafe", cuisine: .indian, price: .midRange, rating: 4.5, dietaryRestrictions: [.vegan, .vegetarian, .kosher], isLastAdded: true, isPopular: false, isCitizensPick: false, menuLink: "https://milimon.ru/benjamincafe/", latitude: 53.188479, longitude: 50.089758),
        Restaurant(name: "Perchini", imageName: "perchini", cuisine: .italian, price: .midRange, rating: 4.7, dietaryRestrictions: [.vegan, .vegetarian, .lactoseFree], isLastAdded: false, isPopular: true, isCitizensPick: false, menuLink: "https://menu.perchini.ru", latitude: 53.202672, longitude: 50.141016),
        Restaurant(name: "Livingstone", imageName: "livingstone", cuisine: .mixed, price: .expensive, rating: 4.3, dietaryRestrictions: [.glutenFree, .lactoseFree], isLastAdded: false, isPopular: true, isCitizensPick: false, menuLink: "https://milimon.ru/livingstone/", latitude: 53.215774, longitude: 50.145289),
        Restaurant(name: "Iscra", imageName: "iscra", cuisine: .italian, price: .midRange, rating: 4.9, dietaryRestrictions: [.vegan, .vegetarian], isLastAdded: false, isPopular: false, isCitizensPick: true, menuLink: "https://iskra-cafe.vsite.biz", latitude: 53.204506, longitude: 50.116942),
        Restaurant(name: "Tanuki", imageName: "tanuki", cuisine: .panAsian, price: .expensive, rating: 4.3, dietaryRestrictions: [.vegan, .vegetarian, .lactoseFree, .glutenFree], isLastAdded: false, isPopular: false, isCitizensPick: true, menuLink: "https://tanukifamily.ru/tanuki/samara/top/", latitude: 53.202249, longitude: 50.1428),
        Restaurant(name: "Surf Coffee", imageName: "surfCoffee", cuisine: .european, price: .cheap, rating: 4.7, dietaryRestrictions: [.vegan, .glutenFree, .lactoseFree], isLastAdded: true, isPopular: false, isCitizensPick: false, menuLink: "https://eda.yandex.ru/samara/r/surf_coffee", latitude: 53.206893, longitude: 50.122089),
        Restaurant(name: "Coffee Cake", imageName: "coffeeCake", cuisine: .mixed, price: .cheap, rating: 4.8, dietaryRestrictions: [.lactoseFree, .glutenFree], isLastAdded: false, isPopular: true, isCitizensPick: false, menuLink: "https://coffee-cake.net/samara#rec80393185", latitude: 53.20914, longitude: 50.118552),
        Restaurant(name: "Comod", imageName: "comod", cuisine: .mixed, price: .cheap, rating: 5.0, dietaryRestrictions: [.glutenFree, .lactoseFree, .vegan, .vegetarian], isLastAdded: false, isPopular: false, isCitizensPick: true, menuLink: "https://komod-samara.vsite.biz", latitude: 53.201183, longitude: 50.110959)
    ]
    
    var favoriteRestaurants: [Restaurant] {
        get {
            return unarchiveJSON(key: "favoriteItems") ?? []
        } set {
            archiveJSON(value: newValue, key: "favoriteItems")
        }
    }
    
    private init() { }
    
    //MARK: – Encoding & Decoding
    private func archiveJSON<T: Encodable>(value: T, key: String) {
        do {
            let data = try JSONEncoder().encode(value)
            let string = String(data: data, encoding: .utf8)
            defaults.set(string, forKey: key)
        } catch {
            debugPrint("Error occured when encoding data")
        }
    }
    
    private func unarchiveJSON<T: Decodable>(key: String) -> T? {
        guard let string = defaults.string(forKey: key), let data = string.data(using: .utf8) else { return nil }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            debugPrint("Error occured when decoding data")
            return nil
        }
    }
}
