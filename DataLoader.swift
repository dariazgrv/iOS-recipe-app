//
//  DataLoader.swift
//  TastyRecipes
//
//  Created by Daria Zugravu on 4/6/20.
//  Copyright © 2020 Daria Zugravu. All rights reserved.
//

import Foundation
//
//public class DataLoader {
//    
//    @Published var recipeData = [RecipeData]()
//    
//    init() {
//        load()
//        sort()
//    }
//    
//    func load() {
//        
//        if let fileLocation = Bundle.main.url(forResource: "recipes", withExtension: "json") {
//            
//            do{
//                
//                let data = try Data(contentsOf: fileLocation)
//                
//                let jsonDecoder = JSONDecoder()
//                let dataFromJson = try jsonDecoder.decode([RecipeData].self, from: data)
//                
//                self.recipeData = dataFromJson
//            } catch {
//                print(error)
//            }
//        }
//        
//    }
//    
//    func sort(){
//        self.recipeData = self.recipeData.sorted(by: { $0.recipe_id < $1.recipe_id})
//    }
//}
