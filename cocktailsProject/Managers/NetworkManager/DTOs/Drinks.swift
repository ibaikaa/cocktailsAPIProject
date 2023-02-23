//
//  Drinks.swift
//  cocktailsProject
//
//  Created by ibaikaa on 21/2/23.
//

import Foundation

struct DrinksGroup: Decodable {
    var drinks: [Drink]?
}

struct Drink: Decodable {
    let name: String
    let imageURLPath: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case name = "strDrink"
        case imageURLPath = "strDrinkThumb"
        case description = "strInstructions"
    }
}
