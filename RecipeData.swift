//
//  RecipeData.swift
//  TastyRecipes
//
//  Created by Daria Zugravu on 4/6/20.
//  Copyright © 2020 Daria Zugravu. All rights reserved.
//

import Foundation

//Codable allows me to convert JSON data
struct RecipeData: Codable, Comparable {
    
    var id: String?
    var recipeCategory: String?
    var recipeTitle: String?
    var recipeIngredients: String?
    var recipeSteps: String?
    var recipeLikes: Int?
    var recipeTime: String?
    var photoURL: String?
    
    
    init(id:String?, recipeCategory: String?, recipeTitle: String?, recipeIngredients: String?, recipeSteps: String?, recipeLikes: Int?, recipeTime: String?, photoURL: String?){
        
        self.id = id
        self.recipeCategory = recipeCategory
        self.recipeTitle = recipeTitle
        self.recipeIngredients = recipeIngredients
        self.recipeSteps = recipeSteps
        self.recipeLikes = recipeLikes
        self.recipeTime = recipeTime
        self.photoURL = photoURL
    }
    
    
    static func <(lhs: RecipeData, rhs: RecipeData) -> Bool {
        return lhs.recipeLikes ?? 0 < rhs.recipeLikes ?? 0
    }

    
    
}
