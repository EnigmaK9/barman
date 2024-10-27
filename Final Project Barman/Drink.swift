//
//  Drink.swift
//  Project Barman
//
//  Created by Carlos Ignacio Padilla Herrera on 26/10/24.
//
//  Description: A model was defined to represent a drink, including its name, ingredients, directions, and image URL.
//
//  Created for: Enigma Unit
//  Version: 1.0.0
//  Copyright © 2024 Enigma Unit. All rights reserved.
//


import Foundation

struct Drink: Codable {
    var name: String
    var ingredients: String
    var directions: String
    var img: String
}
