//
//  Drink.swift
//  cloudTag
//
//  Created by Артем Соловьев on 03.04.2022.
//

import Foundation

struct All: Codable {
    let drinks: [Drink]
}

// MARK: - Drink
struct Drink: Codable {
    let strDrink: String
    let strDrinkThumb: String
    let idDrink: String
}
