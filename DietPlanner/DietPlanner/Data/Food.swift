//
//  Food.swift
//  DietPlanner
//
//  Created by Eric Zacharia on 4/9/21.
//

import Foundation

class Food: CustomDebugStringConvertible, Codable {
    var debugDescription: String {
        return "Food(food: \(self.name), description: \(self.caloriesString))"   }

    var name: String
    var caloriesString: String
    var calories: Int16
    var protein: Int16
    var carbohydrates: Int16
    var fat: Int16
    var imageUrl: String
    var confirmedLiked: Bool = false
    var confirmedDisliked: Bool = false
    var confirmedLikedIndifferent: Bool = true
    var confirmedDislikedIndifferent: Bool = true

    private enum CodingKeys: String, CodingKey{
        case name, caloriesString, calories, protein, carbohydrates, fat, imageUrl
    }
    init(called name: String, caloriesString: String, calories: Int16, protein: Int16, carbohydrates: Int16, fat: Int16, imageUrl: String) {
        self.name = name
        self.caloriesString = caloriesString
        self.calories = calories
        self.protein = protein
        self.carbohydrates = carbohydrates
        self.fat = fat
        self.imageUrl = imageUrl
    }
}

struct FoodResult: Codable {
    let foods: [Food]
}

