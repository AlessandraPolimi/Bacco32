//
//  FoodModel.swift
//  BACCO
//
//  Created by GIF on 10/05/24.
//

import Foundation
import SwiftData

// ALIMENTI AGGIUNTI

@Model
class AddedFood {
    var name: String
    var grams: Double
    var date: Date
    
    init(name: String, grams: Double, date: Date) {
        self.name = name
        self.grams = grams
        self.date = date
    }
}



func populateProve(context: ModelContext) {
    let calendar = Calendar.current
    // Ottiene la data di ieri
    let ieri = calendar.date(byAdding: .day, value: -2, to: Date())!
    let ierii = calendar.date(byAdding: .day, value: -3, to: Date())!
    let ieriii = calendar.date(byAdding: .day, value: -4, to: Date())!

    
    let prova1 = BaccoIndexes(nutritionIndexes: (.init(carbTotal: 400, proteinTotal: 20, fatTotal: 30, MacronutrientsIndex: 40, DietQualityIndex: 30, NutritionIndexOverall: 50)), mentalHealthIndexes: (.init(sdnnIndex: 80, rmssdIndex: 80, MentalHealthIndexOverall: 12)), physicalActivityIndexes: 20, baccoIndex: 90, date: ieri)
    let prova2 = BaccoIndexes(nutritionIndexes: (.init(carbTotal: 300, proteinTotal: 40, fatTotal: 30, MacronutrientsIndex: 40, DietQualityIndex: 30, NutritionIndexOverall: 20)), mentalHealthIndexes: (.init(sdnnIndex: 80, rmssdIndex: 80, MentalHealthIndexOverall: 80)), physicalActivityIndexes: 30, baccoIndex: 40, date: ierii)
    let prova3 = BaccoIndexes(nutritionIndexes: (.init(carbTotal: 100, proteinTotal: 40, fatTotal: 30, MacronutrientsIndex: 40, DietQualityIndex: 30, NutritionIndexOverall: 25)), mentalHealthIndexes: (.init(sdnnIndex: 10, rmssdIndex: 80, MentalHealthIndexOverall: 20)), physicalActivityIndexes: 50, baccoIndex: 40, date: ieriii)
}




@Model
class BaccoIndexes: Identifiable {
    var id = UUID()
    var nutritionIndexes: NutritionIndexes
    var mentalHealthIndexes: MentalHealthIndexes
    var physicalActivityIndexes: Double
    var baccoIndex: Double
    var date: Date
    
    init(nutritionIndexes: NutritionIndexes, mentalHealthIndexes: MentalHealthIndexes, physicalActivityIndexes: Double, baccoIndex: Double, date: Date) {
        self.nutritionIndexes = nutritionIndexes
        self.mentalHealthIndexes = mentalHealthIndexes
        self.physicalActivityIndexes = physicalActivityIndexes
        self.baccoIndex = baccoIndex
        self.date = date
    }
}

struct NutritionIndexes: Codable, Hashable {
    var carbTotal: Double
    var proteinTotal: Double
    var fatTotal: Double
    var MacronutrientsIndex: Double
    var DietQualityIndex: Double
    var NutritionIndexOverall: Double
}

struct MentalHealthIndexes: Codable, Hashable {
    var sdnnIndex: Double
    var rmssdIndex: Double
    var MentalHealthIndexOverall: Double
}





// VECCHIO
@Model
class NutritionIndexes_OLD {
    var MacronutrientsIndex = 0.0
    var DietQualityIndex = 0.0
    var NutritionIndexOverall = 0.0
    var date = Date.now
    
    init(MacronutrientsIndex: Double = 0.0, DietQualityIndex: Double = 0.0, NutritionIndexOverall: Double = 0.0, date: Foundation.Date = Date.now) {
        self.MacronutrientsIndex = MacronutrientsIndex
        self.DietQualityIndex = DietQualityIndex
        self.NutritionIndexOverall = NutritionIndexOverall
        self.date = date
    }
    
}
