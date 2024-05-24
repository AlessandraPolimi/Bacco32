//
//  FoodDatabase.swift
//  BACCO
//
//  Created by GIF on 10/05/24.
//


// FOOD DATABASE
import Foundation
import SwiftData

// LEGENDA CODICE:
// meat -> code 1
// poultry -> code 2
// fish -> code 3
// eggs -> code 4
// dairy -> code 5
// beans -> code 6
// grain -> code 7
// fruit -> code 8
// vegetable -> code 9

@Model
class FoodItem {
    var name: String
    var code: FoodCode
    var carb: Double
    var protein: Double
    var fat: Double
    var servingSize: Double
    var calories: Double
    
    var fiber: Double
    var iron: Double
    var calcium: Double
    var vitaminC: Double
    var saturedFat: Double
    var MUFA: Double // monoinsaturi
    var PUFA: Double // polinsaturi
    var cholesterol: Double
    var sodium: Double
    
    init(name: String, code: FoodCode, carb: Double, protein: Double, fat: Double, servingSize: Double, calories: Double, fiber: Double, iron: Double, calcium: Double, vitaminC: Double, saturedFat: Double, MUFA: Double, PUFA: Double, cholesterol: Double, sodium: Double) {
        self.name = name
        self.code = code
        self.carb = carb
        self.protein = protein
        self.fat = fat
        self.servingSize = servingSize
        self.calories = calories
        self.fiber = fiber
        self.iron = iron
        self.calcium = calcium
        self.vitaminC = vitaminC
        self.saturedFat = saturedFat
        self.MUFA = MUFA
        self.PUFA = PUFA
        self.cholesterol = cholesterol
        self.sodium = sodium
    }
    
}

// modificare il code come un enum

enum FoodCode: Int, Codable, Hashable {
    case meat = 1
    case poultry = 2
    case fish = 3
    case egg = 4
    case dairy = 5
    case beans = 6
    case grain = 7
    case fruit = 8
    case vegetable = 9
    case emptyCalories = 10
}



/*
func populateFoodDatabase(context: ModelContext) {
 let foodItem1 = FoodItem(name: "Pasta", code: FoodCode(rawValue: 7)!, carb: 20.0, protein: 23.0, fat: 3.0, servingSize: 30, calories: 230, fiber: 23, iron: 22, calcium: 2, vitaminC: 2, saturedFat: 2, MUFA: 2, PUFA: 2, cholesterol: 2, sodium: 2)
 let foodItem2 = FoodItem(name: "Broccoli", code: FoodCode(rawValue: 9)!, carb: 6.64, protein: 2.82, fat: 0.37, servingSize: 91, calories: 35, fiber: 2.6, iron: 0.73, calcium: 47, vitaminC: 89.2, saturedFat: 0.039, MUFA: 0.011, PUFA: 0.031, cholesterol: 0, sodium: 33)
 let foodItem3 = FoodItem(name: "Chicken Breast", code: FoodCode(rawValue: 2)!, carb: 0, protein: 31, fat: 3.6, servingSize: 120, calories: 149, fiber: 0, iron: 0.4, calcium: 11, vitaminC: 0, saturedFat: 1, MUFA: 1.2, PUFA: 0.7, cholesterol: 83, sodium: 70)
 let foodItem4 = FoodItem(name: "Salmon", code: FoodCode(rawValue: 3)!, carb: 0, protein: 20.42, fat: 13.42, servingSize: 100, calories: 208, fiber: 0, iron: 0.15, calcium: 9, vitaminC: 0, saturedFat: 3.1, MUFA: 3.8, PUFA: 3.9, cholesterol: 55, sodium: 59)
 let foodItem5 = FoodItem(name: "Whole Milk", code: FoodCode(rawValue: 5)!, carb: 4.88, protein: 3.28, fat: 3.25, servingSize: 244, calories: 61, fiber: 0, iron: 0, calcium: 113, vitaminC: 0, saturedFat: 1.865, MUFA: 0.812, PUFA: 0.195, cholesterol: 12, sodium: 98)
 let foodItem6 = FoodItem(name: "Eggs (normal)", code: FoodCode(rawValue: 4)!, carb: 1.12, protein: 12.56, fat: 10.6, servingSize: 50, calories: 143, fiber: 0, iron: 1.75, calcium: 56, vitaminC: 0, saturedFat: 3.3, MUFA: 4.1, PUFA: 1.4, cholesterol: 372, sodium: 124)
 let foodItem7 = FoodItem(name: "White Bread", code: FoodCode(rawValue: 7)!, carb: 49, protein: 9, fat: 3.2, servingSize: 30, calories: 265, fiber: 2.7, iron: 3.6, calcium: 130, vitaminC: 0, saturedFat: 0.7, MUFA: 0.4, PUFA: 1.8, cholesterol: 0, sodium: 491)
 let foodItem8 = FoodItem(name: "Apple", code: FoodCode(rawValue: 8)!, carb: 13.81, protein: 0.26, fat: 0.17, servingSize: 100, calories: 52, fiber: 2.4, iron: 0.12, calcium: 6, vitaminC: 4.6, saturedFat: 0.028, MUFA: 0.007, PUFA: 0.051, cholesterol: 0, sodium: 1)
 let foodItem9 = FoodItem(name: "Potato Chips", code: FoodCode(rawValue: 10)!, carb: 57.2, protein: 6.6, fat: 35.5, servingSize: 28, calories: 536, fiber: 4.8, iron: 0.8, calcium: 17, vitaminC: 6.2, saturedFat: 3.3, MUFA: 9.5, PUFA: 17.1, cholesterol: 0, sodium: 526)
 let foodItem10 = FoodItem(name: "Oats", code: FoodCode(rawValue: 7)!, carb: 66.3, protein: 16.9, fat: 6.9, servingSize: 30, calories: 389, fiber: 10.6, iron: 4.72, calcium: 54, vitaminC: 0, saturedFat: 1.217, MUFA: 2.178, PUFA: 2.535, cholesterol: 0, sodium: 2)
 let foodItem11 = FoodItem(name: "Beans", code: FoodCode(rawValue: 6)!, carb: 63.6, protein: 21.1, fat: 0.8, servingSize: 100, calories: 347, fiber: 15.2, iron: 5.1, calcium: 143, vitaminC: 4.5, saturedFat: 0.202, MUFA: 0.107, PUFA: 0.401, cholesterol: 0, sodium: 12)
 let foodItem12 = FoodItem(name: "Chickpeas", code: FoodCode(rawValue: 6)!, carb: 61, protein: 19, fat: 6, servingSize: 100, calories: 364, fiber: 17, iron: 6.24, calcium: 105, vitaminC: 4, saturedFat: 0.6, MUFA: 1.4, PUFA: 2.7, cholesterol: 0, sodium: 24)
 let foodItem13 = FoodItem(name: "Pizza", code: FoodCode(rawValue: 10)!, carb: 28, protein: 11, fat: 10, servingSize: 100, calories: 266, fiber: 2, iron: 2.0, calcium: 150, vitaminC: 3, saturedFat: 4.8, MUFA: 3.2, PUFA: 2.1, cholesterol: 18, sodium: 640)
 let foodItem14 = FoodItem(name: "Rice", code: FoodCode(rawValue: 7)!, carb: 28.2, protein: 2.7, fat: 0.3, servingSize: 100, calories: 130, fiber: 0.4, iron: 0.2, calcium: 10, vitaminC: 0, saturedFat: 0.1, MUFA: 0.1, PUFA: 0.1, cholesterol: 0, sodium: 1)
 let foodItem15 = FoodItem(name: "Zucchini", code: FoodCode(rawValue: 9)!, carb: 3.11, protein: 1.21, fat: 0.32, servingSize: 100, calories: 17, fiber: 1, iron: 0.37, calcium: 16, vitaminC: 17.9, saturedFat: 0.07, MUFA: 0.048, PUFA: 0.166, cholesterol: 0, sodium: 8)
 let foodItem16 = FoodItem(name: "Bovine Meat", code: FoodCode(rawValue: 1)!, carb: 0, protein: 26, fat: 15, servingSize: 100, calories: 250, fiber: 0, iron: 2.6, calcium: 12, vitaminC: 0, saturedFat: 5.8, MUFA: 6.8, PUFA: 0.6, cholesterol: 90, sodium: 55)

 
 let foodItem17 = FoodItem(name: "Tofu", code: FoodCode(rawValue: 6)!, carb: 1.9, protein: 8, fat: 4.8, servingSize: 85, calories: 76, fiber: 0.3, iron: 1.2, calcium: 350, vitaminC: 0, saturedFat: 0.7, MUFA: 1, PUFA: 2.7, cholesterol: 0, sodium: 7)
     let foodItem18 = FoodItem(name: "Tempeh", code: FoodCode(rawValue: 6)!, carb: 9.4, protein: 18.5, fat: 10.8, servingSize: 85, calories: 195, fiber: 0, iron: 2.7, calcium: 96, vitaminC: 0, saturedFat: 2.2, MUFA: 2.6, PUFA: 6, cholesterol: 0, sodium: 9)
     let foodItem19 = FoodItem(name: "Edamame", code: FoodCode(rawValue: 6)!, carb: 11, protein: 12, fat: 5, servingSize: 75, calories: 122, fiber: 5, iron: 2.3, calcium: 63, vitaminC: 6.1, saturedFat: 0.6, MUFA: 1.3, PUFA: 2.4, cholesterol: 0, sodium: 6)
     let foodItem20 = FoodItem(name: "Tomatoes", code: FoodCode(rawValue: 9)!, carb: 3.9, protein: 0.9, fat: 0.2, servingSize: 123, calories: 18, fiber: 1.2, iron: 0.3, calcium: 10, vitaminC: 14, saturedFat: 0.03, MUFA: 0.03, PUFA: 0.08, cholesterol: 0, sodium: 5)
     let foodItem21 = FoodItem(name: "Eggplant", code: FoodCode(rawValue: 9)!, carb: 5.88, protein: 0.98, fat: 0.18, servingSize: 82, calories: 25, fiber: 3, iron: 0.23, calcium: 9, vitaminC: 2.2, saturedFat: 0.034, MUFA: 0.076, PUFA: 0.078, cholesterol: 0, sodium: 2)
     let foodItem22 = FoodItem(name: "Italian Flatbread (Piadina)", code: FoodCode(rawValue: 7)!, carb: 49.2, protein: 7.9, fat: 10.2, servingSize: 100, calories: 319, fiber: 2.4, iron: 3.1, calcium: 130, vitaminC: 0, saturedFat: 4.3, MUFA: 4.1, PUFA: 1.5, cholesterol: 20, sodium: 500)
     let foodItem23 = FoodItem(name: "Mozzarella", code: FoodCode(rawValue: 5)!, carb: 1.03, protein: 28, fat: 17, servingSize: 113, calories: 280, fiber: 0, iron: 0.22, calcium: 505, vitaminC: 0, saturedFat: 10.85, MUFA: 4.9, PUFA: 0.6, cholesterol: 54, sodium: 629)
     let foodItem24 = FoodItem(name: "Stracchino", code: FoodCode(rawValue: 5)!, carb: 2.5, protein: 10.5, fat: 20.3, servingSize: 50, calories: 252, fiber: 0, iron: 0.3, calcium: 240, vitaminC: 0, saturedFat: 12.8, MUFA: 5.4, PUFA: 0.8, cholesterol: 80, sodium: 400)
     let foodItem25 = FoodItem(name: "Whole Wheat Pasta", code: FoodCode(rawValue: 7)!, carb: 72, protein: 15, fat: 1.3, servingSize: 140, calories: 352, fiber: 10.7, iron: 3.6, calcium: 41, vitaminC: 0, saturedFat: 0.3, MUFA: 0.2, PUFA: 0.5, cholesterol: 0, sodium: 12)
     let foodItem26 = FoodItem(name: "Whole Grain Bread", code: FoodCode(rawValue: 7)!, carb: 43, protein: 13, fat: 4.2, servingSize: 50, calories: 247, fiber: 7, iron: 2.9, calcium: 80, vitaminC: 0, saturedFat: 0.9, MUFA: 0.9, PUFA: 2.1, cholesterol: 0, sodium: 380)
     let foodItem27 = FoodItem(name: "Greek Yogurt", code: FoodCode(rawValue: 5)!, carb: 4, protein: 9, fat: 0.4, servingSize: 150, calories: 59, fiber: 0, iron: 0, calcium: 110, vitaminC: 0, saturedFat: 0.1, MUFA: 0.1, PUFA: 0.1, cholesterol: 5, sodium: 36)
     let foodItem28 = FoodItem(name: "Soy Milk", code: FoodCode(rawValue: 5)!, carb: 6, protein: 3.3, fat: 1.8, servingSize: 240, calories: 54, fiber: 0.5, iron: 0.6, calcium: 25, vitaminC: 0, saturedFat: 0.2, MUFA: 0.4, PUFA: 1, cholesterol: 0, sodium: 51)
     let foodItem29 = FoodItem(name: "Partly Skimmed Milk", code: FoodCode(rawValue: 5)!, carb: 5, protein: 3.4, fat: 1.7, servingSize: 240, calories: 46, fiber: 0, iron: 0, calcium: 123, vitaminC: 0, saturedFat: 1.07, MUFA: 0.5, PUFA: 0.1, cholesterol: 5, sodium: 42)
 
 
 let foodItem30 = FoodItem(name: "Chocolate", code: FoodCode(rawValue: 10)!, carb: 45.9, protein: 5.4, fat: 29.7, servingSize: 50, calories: 546, fiber: 7.0, iron: 12.02, calcium: 56, vitaminC: 0, saturedFat: 18.1, MUFA: 9.8, PUFA: 1.2, cholesterol: 23, sodium: 24)
     let foodItem31 = FoodItem(name: "Strawberry", code: FoodCode(rawValue: 8)!, carb: 7.7, protein: 0.7, fat: 0.3, servingSize: 152, calories: 32, fiber: 2.0, iron: 0.41, calcium: 16, vitaminC: 58.8, saturedFat: 0.015, MUFA: 0.043, PUFA: 0.155, cholesterol: 0, sodium: 1)
     let foodItem32 = FoodItem(name: "Banana", code: FoodCode(rawValue: 8)!, carb: 22.84, protein: 1.09, fat: 0.33, servingSize: 118, calories: 89, fiber: 2.6, iron: 0.26, calcium: 5, vitaminC: 8.7, saturedFat: 0.112, MUFA: 0.032, PUFA: 0.073, cholesterol: 0, sodium: 1)
     let foodItem33 = FoodItem(name: "Apricot", code: FoodCode(rawValue: 8)!, carb: 11.12, protein: 1.4, fat: 0.39, servingSize: 35, calories: 48, fiber: 2.0, iron: 0.39, calcium: 13, vitaminC: 10, saturedFat: 0.027, MUFA: 0.077, PUFA: 0.086, cholesterol: 0, sodium: 1)
     let foodItem34 = FoodItem(name: "Canned Tuna", code: FoodCode(rawValue: 3)!, carb: 0, protein: 25.5, fat: 8.2, servingSize: 85, calories: 186, fiber: 0, iron: 1.4, calcium: 37, vitaminC: 0, saturedFat: 2.2, MUFA: 2.7, PUFA: 2.1, cholesterol: 30, sodium: 453)
     let foodItem35 = FoodItem(name: "Spelt (Farro)", code: FoodCode(rawValue: 7)!, carb: 70.19, protein: 14.57, fat: 2.43, servingSize: 45, calories: 338, fiber: 10.7, iron: 4.44, calcium: 27, vitaminC: 0, saturedFat: 0.427, MUFA: 0.29, PUFA: 1.27, cholesterol: 0, sodium: 8)
     let foodItem36 = FoodItem(name: "Barley (Orzo)", code: FoodCode(rawValue: 7)!, carb: 77.7, protein: 12.5, fat: 1.16, servingSize: 45, calories: 354, fiber: 15.6, iron: 3.6, calcium: 33, vitaminC: 0, saturedFat: 0.24, MUFA: 0.15, PUFA: 0.57, cholesterol: 0, sodium: 12)
     let foodItem37 = FoodItem(name: "Jam", code: FoodCode(rawValue: 10)!, carb: 68, protein: 0.5, fat: 0.1, servingSize: 20, calories: 278, fiber: 1.2, iron: 0.3, calcium: 10, vitaminC: 0, saturedFat: 0.01, MUFA: 0.01, PUFA: 0.04, cholesterol: 0, sodium: 30)
     let foodItem38 = FoodItem(name: "Crispbread", code: FoodCode(rawValue: 7)!, carb: 80.5, protein: 10.7, fat: 1.3, servingSize: 25, calories: 374, fiber: 14.5, iron: 2.9, calcium: 28, vitaminC: 0, saturedFat: 0.3, MUFA: 0.5, PUFA: 0.4, cholesterol: 0, sodium: 380)
     let foodItem39 = FoodItem(name: "Lentils", code: FoodCode(rawValue: 6)!, carb: 60, protein: 25, fat: 0.8, servingSize: 50, calories: 353, fiber: 31, iron: 7.5, calcium: 56, vitaminC: 4.5, saturedFat: 0.1, MUFA: 0.2, PUFA: 0.5, cholesterol: 0, sodium: 2)
     let foodItem40 = FoodItem(name: "Lettuce", code: FoodCode(rawValue: 9)!, carb: 2.9, protein: 1.36, fat: 0.15, servingSize: 85, calories: 15, fiber: 1.3, iron: 0.86, calcium: 36, vitaminC: 9.2, saturedFat: 0.02, MUFA: 0.01, PUFA: 0.12, cholesterol: 0, sodium: 28)
     let foodItem41 = FoodItem(name: "Arugula (Rucola)", code: FoodCode(rawValue: 9)!, carb: 3.65, protein: 2.58, fat: 0.66, servingSize: 85, calories: 25, fiber: 1.6, iron: 1.46, calcium: 160, vitaminC: 15, saturedFat: 0.086, MUFA: 0.07, PUFA: 0.321, cholesterol: 0, sodium: 27)
     let foodItem42 = FoodItem(name: "Walnuts", code: FoodCode(rawValue: 10)!, carb: 13.71, protein: 15.23, fat: 65.21, servingSize: 30, calories: 654, fiber: 6.7, iron: 2.91, calcium: 98, vitaminC: 1.3, saturedFat: 6.126, MUFA: 8.933, PUFA: 47.174, cholesterol: 0, sodium: 2)
     let foodItem43 = FoodItem(name: "Hazelnuts", code: FoodCode(rawValue: 10)!, carb: 16.7, protein: 14.95, fat: 60.75, servingSize: 30, calories: 628, fiber: 9.7, iron: 4.7, calcium: 114, vitaminC: 6.3, saturedFat: 4.464, MUFA: 45.652, PUFA: 7.92, cholesterol: 0, sodium: 0)
     let foodItem44 = FoodItem(name: "Almonds", code: FoodCode(rawValue: 10)!, carb: 21.55, protein: 21.15, fat: 49.93, servingSize: 30, calories: 579, fiber: 12.5, iron: 3.71, calcium: 269, vitaminC: 0, saturedFat: 3.802, MUFA: 30.889, PUFA: 12.07, cholesterol: 0, sodium: 1)
     let foodItem45 = FoodItem(name: "Cashews", code: FoodCode(rawValue: 10)!, carb: 30.19, protein: 18.22, fat: 43.85, servingSize: 30, calories: 553, fiber: 3.3, iron: 6.68, calcium: 37, vitaminC: 0.5, saturedFat: 7.783, MUFA: 23.797, PUFA: 7.845, cholesterol: 0, sodium: 12)
     let foodItem46 = FoodItem(name: "Coca Cola", code: FoodCode(rawValue: 10)!, carb: 10.6, protein: 0, fat: 0, servingSize: 355, calories: 42, fiber: 0, iron: 0, calcium: 0, vitaminC: 0, saturedFat: 0, MUFA: 0, PUFA: 0, cholesterol: 0, sodium: 4)
     let foodItem47 = FoodItem(name: "Fanta", code: FoodCode(rawValue: 10)!, carb: 11.3, protein: 0, fat: 0, servingSize: 355, calories: 45, fiber: 0, iron: 0, calcium: 0, vitaminC: 0, saturedFat: 0, MUFA: 0, PUFA: 0, cholesterol: 0, sodium: 7)
     let foodItem48 = FoodItem(name: "Spritz", code: FoodCode(rawValue: 10)!, carb: 8.0, protein: 0, fat: 0, servingSize: 150, calories: 83, fiber: 0, iron: 0, calcium: 0, vitaminC: 0, saturedFat: 0, MUFA: 0, PUFA: 0, cholesterol: 0, sodium: 3)
     let foodItem49 = FoodItem(name: "Olive Oil", code: FoodCode(rawValue: 10)!, carb: 0, protein: 0, fat: 100, servingSize: 15, calories: 884, fiber: 0, iron: 0.56, calcium: 1, vitaminC: 0, saturedFat: 13.808, MUFA: 72.961, PUFA: 10.523, cholesterol: 0, sodium: 2)
     let foodItem50 = FoodItem(name: "Butter", code: FoodCode(rawValue: 5)!, carb: 0.06, protein: 0.85, fat: 81.11, servingSize: 14, calories: 717, fiber: 0, iron: 0.02, calcium: 24, vitaminC: 0, saturedFat: 51.368, MUFA: 21.021, PUFA: 3.043, cholesterol: 215, sodium: 11)


 context.insert(foodItem1)
 context.insert(foodItem2)
 context.insert(foodItem3)
 context.insert(foodItem4)
 context.insert(foodItem5)
 context.insert(foodItem6)
 context.insert(foodItem7)
 context.insert(foodItem8)
 context.insert(foodItem9)
 context.insert(foodItem10)
 context.insert(foodItem11)
 context.insert(foodItem12)
 context.insert(foodItem13)
 context.insert(foodItem14)
 context.insert(foodItem15)
 context.insert(foodItem16)
 context.insert(foodItem17)
 context.insert(foodItem18)
 context.insert(foodItem19)
 context.insert(foodItem20)
 context.insert(foodItem21)
 context.insert(foodItem22)
 context.insert(foodItem23)
 context.insert(foodItem24)
 context.insert(foodItem25)
 context.insert(foodItem26)
 context.insert(foodItem27)
 context.insert(foodItem28)
 context.insert(foodItem29)
 context.insert(foodItem30)
 context.insert(foodItem31)
 context.insert(foodItem32)
 context.insert(foodItem33)
 context.insert(foodItem34)
 context.insert(foodItem35)
 context.insert(foodItem36)
 context.insert(foodItem37)
 context.insert(foodItem38)
 context.insert(foodItem39)
 context.insert(foodItem40)
 context.insert(foodItem41)
 context.insert(foodItem42)
 context.insert(foodItem43)
 context.insert(foodItem44)
 context.insert(foodItem45)
 context.insert(foodItem46)
 context.insert(foodItem47)
 context.insert(foodItem48)
 context.insert(foodItem49)
 context.insert(foodItem50)
}
*/

func populateFoodDatabaseEuropean(context: ModelContext) {
    let foodItem1 = FoodItem(name: "Pasta", code: FoodCode(rawValue: 7)!, carb: 25.0, protein: 5.0, fat: 1.1, servingSize: 80, calories: 104.8, fiber: 1.3, iron: 0.5, calcium: 5.6, vitaminC: 0.0, saturedFat: 0.2, MUFA: 0.3, PUFA: 0.4, cholesterol: 0.0, sodium: 4.0)

    let foodItem2 = FoodItem(name: "Broccoli", code: FoodCode(rawValue: 9)!, carb: 7.0, protein: 2.8, fat: 0.4, servingSize: 200, calories: 68.0, fiber: 5.2, iron: 1.4, calcium: 94.0, vitaminC: 178.4, saturedFat: 0.2, MUFA: 0.0, PUFA: 0.4, cholesterol: 0.0, sodium: 66.0)

    let foodItem3 = FoodItem(name: "Chicken Breast", code: FoodCode(rawValue: 2)!, carb: 0.0, protein: 23.3, fat: 2.6, servingSize: 100, calories: 114.0, fiber: 0.0, iron: 0.7, calcium: 8.0, vitaminC: 0.0, saturedFat: 0.7, MUFA: 0.9, PUFA: 0.6, cholesterol: 63.0, sodium: 55.0)

    let foodItem4 = FoodItem(name: "Salmon", code: FoodCode(rawValue: 3)!, carb: 0.0, protein: 20.0, fat: 13.0, servingSize: 100, calories: 208.0, fiber: 0.0, iron: 0.8, calcium: 12.0, vitaminC: 0.0, saturedFat: 3.1, MUFA: 3.8, PUFA: 3.9, cholesterol: 55.0, sodium: 59.0)

    let foodItem5 = FoodItem(name: "Whole Milk", code: FoodCode(rawValue: 5)!, carb: 4.8, protein: 3.3, fat: 3.7, servingSize: 200, calories: 128.0, fiber: 0.0, iron: 0.0, calcium: 240.0, vitaminC: 0.0, saturedFat: 2.4, MUFA: 1.1, PUFA: 0.1, cholesterol: 13.0, sodium: 88.0)

    let foodItem6 = FoodItem(name: "Semi-Skimmed Milk", code: FoodCode(rawValue: 5)!, carb: 4.9, protein: 3.4, fat: 1.6, servingSize: 200, calories: 94.0, fiber: 0.0, iron: 0.0, calcium: 240.0, vitaminC: 0.0, saturedFat: 1.0, MUFA: 0.5, PUFA: 0.1, cholesterol: 5.0, sodium: 88.0)

    let foodItem7 = FoodItem(name: "Egg", code: FoodCode(rawValue: 4)!, carb: 0.7, protein: 12.6, fat: 9.5, servingSize: 60, calories: 86.0, fiber: 0.0, iron: 1.1, calcium: 34.0, vitaminC: 0.0, saturedFat: 1.8, MUFA: 2.2, PUFA: 1.1, cholesterol: 224.0, sodium: 85.0)

    let foodItem8 = FoodItem(name: "White Bread", code: FoodCode(rawValue: 7)!, carb: 49.0, protein: 8.9, fat: 3.2, servingSize: 50, calories: 132.5, fiber: 1.35, iron: 1.8, calcium: 72.0, vitaminC: 0.0, saturedFat: 0.35, MUFA: 0.6, PUFA: 0.35, cholesterol: 0.0, sodium: 245.5)

    let foodItem9 = FoodItem(name: "Whole Grain Bread", code: FoodCode(rawValue: 7)!, carb: 43.3, protein: 9.6, fat: 2.4, servingSize: 50, calories: 123.5, fiber: 3.35, iron: 1.25, calcium: 53.5, vitaminC: 0.0, saturedFat: 0.3, MUFA: 0.15, PUFA: 0.6, cholesterol: 0.0, sodium: 231.0)

    let foodItem10 = FoodItem(name: "Potato Chips", code: FoodCode(rawValue: 10)!, carb: 53.0, protein: 7.0, fat: 34.0, servingSize: 30, calories: 160.8, fiber: 1.1, iron: 0.5, calcium: 7.2, vitaminC: 4.2, saturedFat: 3.9, MUFA: 3.3, PUFA: 1.6, cholesterol: 0.0, sodium: 157.5)

    let foodItem11 = FoodItem(name: "Apple", code: FoodCode(rawValue: 8)!, carb: 13.8, protein: 0.3, fat: 0.2, servingSize: 150, calories: 78.0, fiber: 3.6, iron: 0.15, calcium: 9.0, vitaminC: 6.9, saturedFat: 0.0, MUFA: 0.0, PUFA: 0.15, cholesterol: 0.0, sodium: 1.5)

    let foodItem12 = FoodItem(name: "Banana", code: FoodCode(rawValue: 8)!, carb: 22.8, protein: 1.1, fat: 0.3, servingSize: 150, calories: 114.0, fiber: 3.9, iron: 0.45, calcium: 7.5, vitaminC: 13.05, saturedFat: 0.15, MUFA: 0.0, PUFA: 0.15, cholesterol: 0.0, sodium: 1.5)

    let foodItem13 = FoodItem(name: "Strawberries", code: FoodCode(rawValue: 8)!, carb: 7.7, protein: 0.8, fat: 0.3, servingSize: 150, calories: 48.0, fiber: 3.0, iron: 0.6, calcium: 24.0, vitaminC: 88.2, saturedFat: 0.0, MUFA: 0.0, PUFA: 0.3, cholesterol: 0.0, sodium: 1.5)

    let foodItem14 = FoodItem(name: "Blueberries", code: FoodCode(rawValue: 8)!, carb: 14.5, protein: 0.7, fat: 0.3, servingSize: 150, calories: 85.5, fiber: 3.6, iron: 0.45, calcium: 9.0, vitaminC: 14.55, saturedFat: 0.0, MUFA: 0.15, PUFA: 0.15, cholesterol: 0.0, sodium: 1.5)

    let foodItem15 = FoodItem(name: "Oatmeal", code: FoodCode(rawValue: 7)!, carb: 66.0, protein: 16.9, fat: 6.9, servingSize: 40, calories: 155.6, fiber: 4.2, iron: 2.0, calcium: 21.6, vitaminC: 0.0, saturedFat: 0.5, MUFA: 0.9, PUFA: 1.0, cholesterol: 0.0, sodium: 0.8)

    let foodItem16 = FoodItem(name: "Beans", code: FoodCode(rawValue: 6)!, carb: 22.8, protein: 8.7, fat: 0.5, servingSize: 150, calories: 190.5, fiber: 11.1, iron: 3.15, calcium: 72.0, vitaminC: 1.8, saturedFat: 0.15, MUFA: 0.0, PUFA: 0.3, cholesterol: 0.0, sodium: 9.0)

    let foodItem17 = FoodItem(name: "Chickpeas", code: FoodCode(rawValue: 6)!, carb: 27.4, protein: 8.9, fat: 2.6, servingSize: 150, calories: 246.0, fiber: 11.4, iron: 4.35, calcium: 73.5, vitaminC: 1.95, saturedFat: 0.45, MUFA: 0.9, PUFA: 1.8, cholesterol: 0.0, sodium: 36.0)

    let foodItem18 = FoodItem(name: "Peas", code: FoodCode(rawValue: 9)!, carb: 14.5, protein: 5.4, fat: 0.4, servingSize: 150, calories: 121.5, fiber: 8.25, iron: 2.25, calcium: 37.5, vitaminC: 21.3, saturedFat: 0.15, MUFA: 0.15, PUFA: 0.3, cholesterol: 0.0, sodium: 7.5)

    let foodItem19 = FoodItem(name: "Edamame", code: FoodCode(rawValue: 6)!, carb: 8.9, protein: 11.9, fat: 5.2, servingSize: 150, calories: 181.5, fiber: 7.8, iron: 3.45, calcium: 94.5, vitaminC: 9.15, saturedFat: 0.9, MUFA: 1.95, PUFA: 3.6, cholesterol: 0.0, sodium: 9.0)

    let foodItem20 = FoodItem(name: "Pizza Margherita", code: FoodCode(rawValue: 10)!, carb: 32.0, protein: 11.0, fat: 7.0, servingSize: 150, calories: 345.0, fiber: 3.0, iron: 3.75, calcium: 300.0, vitaminC: 4.5, saturedFat: 3.0, MUFA: 2.5, PUFA: 0.5, cholesterol: 15.0, sodium: 900.0)

    let foodItem21 = FoodItem(name: "Rice", code: FoodCode(rawValue: 7)!, carb: 28.7, protein: 2.7, fat: 0.3, servingSize: 80, calories: 104.0, fiber: 0.3, iron: 0.16, calcium: 8.0, vitaminC: 0.0, saturedFat: 0.08, MUFA: 0.08, PUFA: 0.08, cholesterol: 0.0, sodium: 0.8)

    let foodItem22 = FoodItem(name: "Zucchini", code: FoodCode(rawValue: 9)!, carb: 3.1, protein: 1.2, fat: 0.3, servingSize: 200, calories: 34.0, fiber: 2.0, iron: 0.6, calcium: 32.0, vitaminC: 35.8, saturedFat: 0.1, MUFA: 0.0, PUFA: 0.2, cholesterol: 0.0, sodium: 16.0)

    let foodItem23 = FoodItem(name: "Bell Peppers", code: FoodCode(rawValue: 9)!, carb: 6.0, protein: 0.9, fat: 0.2, servingSize: 200, calories: 40.0, fiber: 3.2, iron: 0.8, calcium: 12.8, vitaminC: 204.8, saturedFat: 0.2, MUFA: 0.0, PUFA: 0.2, cholesterol: 0.0, sodium: 6.4)

    let foodItem24 = FoodItem(name: "Beef", code: FoodCode(rawValue: 1)!, carb: 0.0, protein: 26.0, fat: 15.0, servingSize: 100, calories: 250.0, fiber: 0.0, iron: 2.6, calcium: 18.0, vitaminC: 0.0, saturedFat: 6.0, MUFA: 7.0, PUFA: 0.4, cholesterol: 80.0, sodium: 72.0)

    let foodItem25 = FoodItem(name: "Tofu", code: FoodCode(rawValue: 6)!, carb: 1.9, protein: 8.1, fat: 4.8, servingSize: 100, calories: 88.0, fiber: 0.4, iron: 2.2, calcium: 184.0, vitaminC: 0.0, saturedFat: 0.9, MUFA: 1.5, PUFA: 3.2, cholesterol: 0.0, sodium: 9.0)

    let foodItem26 = FoodItem(name: "Tempeh", code: FoodCode(rawValue: 6)!, carb: 9.4, protein: 19.0, fat: 11.4, servingSize: 100, calories: 192.0, fiber: 5.0, iron: 2.4, calcium: 111.0, vitaminC: 0.0, saturedFat: 2.5, MUFA: 4.6, PUFA: 3.7, cholesterol: 0.0, sodium: 9.0)

    let foodItem27 = FoodItem(name: "Tomatoes", code: FoodCode(rawValue: 9)!, carb: 3.9, protein: 0.9, fat: 0.2, servingSize: 200, calories: 36.0, fiber: 2.4, iron: 0.6, calcium: 24.0, vitaminC: 29.4, saturedFat: 0.0, MUFA: 0.1, PUFA: 0.1, cholesterol: 0.0, sodium: 10.0)

    let foodItem28 = FoodItem(name: "Eggplant", code: FoodCode(rawValue: 9)!, carb: 5.9, protein: 0.8, fat: 0.2, servingSize: 200, calories: 48.0, fiber: 3.8, iron: 0.4, calcium: 16.0, vitaminC: 2.6, saturedFat: 0.0, MUFA: 0.1, PUFA: 0.1, cholesterol: 0.0, sodium: 4.8)

    let foodItem29 = FoodItem(name: "Carrots", code: FoodCode(rawValue: 9)!, carb: 9.6, protein: 0.9, fat: 0.2, servingSize: 200, calories: 64.0, fiber: 4.4, iron: 0.4, calcium: 52.8, vitaminC: 9.4, saturedFat: 0.0, MUFA: 0.0, PUFA: 0.2, cholesterol: 0.0, sodium: 64.0)

    let foodItem30 = FoodItem(name: "Piadina", code: FoodCode(rawValue: 7)!, carb: 43.5, protein: 6.6, fat: 12.1, servingSize: 100, calories: 314.0, fiber: 1.8, iron: 0.9, calcium: 29.0, vitaminC: 0.0, saturedFat: 5.0, MUFA: 5.6, PUFA: 1.1, cholesterol: 22.0, sodium: 720.0)

    let foodItem31 = FoodItem(name: "Arugula", code: FoodCode(rawValue: 9)!, carb: 3.7, protein: 2.6, fat: 0.7, servingSize: 80, calories: 20.0, fiber: 1.6, iron: 1.3, calcium: 128.0, vitaminC: 12.0, saturedFat: 0.0, MUFA: 0.0, PUFA: 0.5, cholesterol: 0.0, sodium: 8.0)

    let foodItem32 = FoodItem(name: "Stracchino", code: FoodCode(rawValue: 5)!, carb: 0.8, protein: 13.0, fat: 23.0, servingSize: 50, calories: 250.0, fiber: 0.0, iron: 0.1, calcium: 220.0, vitaminC: 0.0, saturedFat: 14.5, MUFA: 6.0, PUFA: 0.5, cholesterol: 68.0, sodium: 60.0)

    let foodItem33 = FoodItem(name: "Whole Grain Pasta", code: FoodCode(rawValue: 7)!, carb: 25.0, protein: 5.0, fat: 1.1, servingSize: 80, calories: 104.8, fiber: 1.3, iron: 0.5, calcium: 7.0, vitaminC: 0.0, saturedFat: 0.2, MUFA: 0.3, PUFA: 0.4, cholesterol: 0.0, sodium: 4.0)

    let foodItem34 = FoodItem(name: "Yogurt", code: FoodCode(rawValue: 5)!, carb: 4.7, protein: 3.5, fat: 3.3, servingSize: 125, calories: 73.75, fiber: 0.0, iron: 0.0, calcium: 150.0, vitaminC: 0.0, saturedFat: 2.6, MUFA: 0.9, PUFA: 0.1, cholesterol: 12.5, sodium: 85.0)

    let foodItem35 = FoodItem(name: "Greek Yogurt", code: FoodCode(rawValue: 5)!, carb: 3.6, protein: 9.0, fat: 5.0, servingSize: 125, calories: 127.5, fiber: 0.0, iron: 0.0, calcium: 150.0, vitaminC: 0.0, saturedFat: 4.1, MUFA: 1.75, PUFA: 0.25, cholesterol: 18.75, sodium: 62.5)

    let foodItem36 = FoodItem(name: "Soy Milk", code: FoodCode(rawValue: 5)!, carb: 4.0, protein: 3.3, fat: 1.8, servingSize: 200, calories: 80.0, fiber: 1.2, iron: 1.2, calcium: 50.0, vitaminC: 0.0, saturedFat: 0.4, MUFA: 0.8, PUFA: 2.0, cholesterol: 0.0, sodium: 96.0)

    let foodItem37 = FoodItem(name: "Oat Milk", code: FoodCode(rawValue: 5)!, carb: 6.8, protein: 1.0, fat: 1.2, servingSize: 200, calories: 76.0, fiber: 2.8, iron: 0.4, calcium: 44.0, vitaminC: 0.0, saturedFat: 0.4, MUFA: 0.8, PUFA: 0.8, cholesterol: 0.0, sodium: 152.0)

    let foodItem38 = FoodItem(name: "Chocolate", code: FoodCode(rawValue: 10)!, carb: 58.0, protein: 7.8, fat: 30.0, servingSize: 30, calories: 174.3, fiber: 0.9, iron: 0.72, calcium: 18.0, vitaminC: 0.0, saturedFat: 5.4, MUFA: 2.7, PUFA: 0.24, cholesterol: 7.5, sodium: 60.0)

    let foodItem39 = FoodItem(name: "Apricot", code: FoodCode(rawValue: 8)!, carb: 3.9, protein: 0.5, fat: 0.1, servingSize: 150, calories: 15.6, fiber: 2.1, iron: 0.45, calcium: 19.5, vitaminC: 15.0, saturedFat: 0.0, MUFA: 0.0, PUFA: 0.15, cholesterol: 0.0, sodium: 1.5)

    let foodItem40 = FoodItem(name: "Canned Tuna", code: FoodCode(rawValue: 3)!, carb: 0.0, protein: 26.0, fat: 1.0, servingSize: 100, calories: 116.0, fiber: 0.0, iron: 1.0, calcium: 15.0, vitaminC: 0.0, saturedFat: 0.2, MUFA: 0.3, PUFA: 0.3, cholesterol: 47.0, sodium: 50.0)

    let foodItem41 = FoodItem(name: "Jam", code: FoodCode(rawValue: 10)!, carb: 60.0, protein: 0.3, fat: 0.2, servingSize: 20, calories: 48.0, fiber: 0.4, iron: 0.1, calcium: 6.0, vitaminC: 2.0, saturedFat: 0.0, MUFA: 0.0, PUFA: 0.1, cholesterol: 0.0, sodium: 5.0)

    let foodItem42 = FoodItem(name: "Rusks (fette biscottate)", code: FoodCode(rawValue: 7)!, carb: 75.0, protein: 11.0, fat: 3.5, servingSize: 30, calories: 84.6, fiber: 1.26, iron: 1.2, calcium: 12.0, vitaminC: 0.0, saturedFat: 0.3, MUFA: 0.15, PUFA: 0.12, cholesterol: 0.0, sodium: 87.0)

    let foodItem43 = FoodItem(name: "Salad", code: FoodCode(rawValue: 9)!, carb: 3.6, protein: 1.0, fat: 0.2, servingSize: 80, calories: 14.4, fiber: 1.9, iron: 0.5, calcium: 14.4, vitaminC: 12.0, saturedFat: 0.08, MUFA: 0.04, PUFA: 0.08, cholesterol: 0.0, sodium: 3.2)

    let foodItem44 = FoodItem(name: "Lentils", code: FoodCode(rawValue: 6)!, carb: 20.1, protein: 9.0, fat: 0.4, servingSize: 150, calories: 189.6, fiber: 12.0, iron: 4.2, calcium: 72.0, vitaminC: 2.25, saturedFat: 0.15, MUFA: 0.15, PUFA: 0.3, cholesterol: 0.0, sodium: 3.6)

    let foodItem45 = FoodItem(name: "Walnuts", code: FoodCode(rawValue: 10)!, carb: 13.7, protein: 15.2, fat: 65.2, servingSize: 30, calories: 196.2, fiber: 2.01, iron: 0.87, calcium: 29.4, vitaminC: 0.39, saturedFat: 1.83, MUFA: 2.67, PUFA: 14.16, cholesterol: 0.0, sodium: 0.6)

    let foodItem46 = FoodItem(name: "Hazelnuts", code: FoodCode(rawValue: 10)!, carb: 16.7, protein: 15.0, fat: 60.8, servingSize: 30, calories: 188.4, fiber: 2.91, iron: 1.41, calcium: 34.2, vitaminC: 1.89, saturedFat: 1.35, MUFA: 13.71, PUFA: 2.37, cholesterol: 0.0, sodium: 0.0)

    let foodItem47 = FoodItem(name: "Almonds", code: FoodCode(rawValue: 10)!, carb: 21.7, protein: 21.2, fat: 49.9, servingSize: 30, calories: 172.5, fiber: 3.75, iron: 1.11, calcium: 79.2, vitaminC: 0.0, saturedFat: 1.14, MUFA: 9.48, PUFA: 3.63, cholesterol: 0.0, sodium: 0.3)

    let foodItem48 = FoodItem(name: "Cashews", code: FoodCode(rawValue: 10)!, carb: 30.2, protein: 18.2, fat: 43.9, servingSize: 30, calories: 172.2, fiber: 0.99, iron: 1.8, calcium: 11.1, vitaminC: 0.15, saturedFat: 2.34, MUFA: 7.14, PUFA: 2.34, cholesterol: 0.0, sodium: 3.6)

    let foodItem49 = FoodItem(name: "Olive Oil", code: FoodCode(rawValue: 10)!, carb: 0.0, protein: 0.0, fat: 100.0, servingSize: 10, calories: 88.4, fiber: 0.0, iron: 0.06, calcium: 0.1, vitaminC: 0.0, saturedFat: 1.4, MUFA: 7.3, PUFA: 1.1, cholesterol: 0.0, sodium: 0.2)

    let foodItem50 = FoodItem(name: "Butter", code: FoodCode(rawValue: 10)!, carb: 0.1, protein: 0.2, fat: 81.1, servingSize: 10, calories: 74.0, fiber: 0.0, iron: 0.02, calcium: 2.0, vitaminC: 0.0, saturedFat: 5.3, MUFA: 2.3, PUFA: 0.2, cholesterol: 23.0, sodium: 7.0)

    let foodItem51 = FoodItem(name: "Potatoes", code: FoodCode(rawValue: 9)!, carb: 17.6, protein: 2.0, fat: 0.1, servingSize: 200, calories: 136.0, fiber: 2.2, iron: 1.1, calcium: 20.0, vitaminC: 19.6, saturedFat: 0.02, MUFA: 0.01, PUFA: 0.04, cholesterol: 0.0, sodium: 14.0)

    let foodItem52 = FoodItem(name: "Spritz", code: FoodCode(rawValue: 10)!, carb: 18.0, protein: 0.0, fat: 0.0, servingSize: 200, calories: 144.0, fiber: 0.0, iron: 0.0, calcium: 0.0, vitaminC: 0.0, saturedFat: 0.0, MUFA: 0.0, PUFA: 0.0, cholesterol: 0.0, sodium: 0.0)
    
    let foodItem53 = FoodItem(name: "Prosciutto Cotto", code: FoodCode(rawValue: 1)!, carb: 1.0, protein: 20.0, fat: 3.0, servingSize: 50, calories: 110.0, fiber: 0.0, iron: 1.2, calcium: 10.0, vitaminC: 0.0, saturedFat: 1.0, MUFA: 1.4, PUFA: 0.5, cholesterol: 50.0, sodium: 900.0)

    let foodItem54 = FoodItem(name: "Prosciutto Crudo", code: FoodCode(rawValue: 1)!, carb: 0.0, protein: 27.0, fat: 19.0, servingSize: 50, calories: 249.0, fiber: 0.0, iron: 2.0, calcium: 20.0, vitaminC: 0.0, saturedFat: 6.2, MUFA: 9.2, PUFA: 1.2, cholesterol: 75.0, sodium: 1230.0)

    let foodItem55 = FoodItem(name: "Mozzarella", code: FoodCode(rawValue: 5)!, carb: 2.2, protein: 18.0, fat: 15.0, servingSize: 100, calories: 280.0, fiber: 0.0, iron: 0.3, calcium: 505.0, vitaminC: 0.0, saturedFat: 10.0, MUFA: 3.6, PUFA: 0.5, cholesterol: 54.0, sodium: 250.0)

    let foodItem56 = FoodItem(name: "Sea Bass", code: FoodCode(rawValue: 3)!, carb: 0.0, protein: 20.8, fat: 2.0, servingSize: 100, calories: 97.0, fiber: 0.0, iron: 0.3, calcium: 10.0, vitaminC: 0.0, saturedFat: 0.5, MUFA: 0.6, PUFA: 0.7, cholesterol: 58.0, sodium: 68.0)

    let foodItem57 = FoodItem(name: "Dark Chocolate", code: FoodCode(rawValue: 10)!, carb: 46.0, protein: 7.9, fat: 43.0, servingSize: 30, calories: 230.0, fiber: 10.9, iron: 11.9, calcium: 73.0, vitaminC: 0.0, saturedFat: 24.5, MUFA: 12.6, PUFA: 1.3, cholesterol: 5.0, sodium: 20.0)

    let foodItem58 = FoodItem(name: "Oro Saiwa Biscuits", code: FoodCode(rawValue: 10)!, carb: 71.5, protein: 7.6, fat: 13.5, servingSize: 30, calories: 401.0, fiber: 2.4, iron: 3.2, calcium: 40.0, vitaminC: 0.0, saturedFat: 2.8, MUFA: 3.6, PUFA: 6.0, cholesterol: 0.0, sodium: 400.0)

    let foodItem59 = FoodItem(name: "Gocciole Biscuits", code: FoodCode(rawValue: 10)!, carb: 63.0, protein: 6.4, fat: 23.0, servingSize: 30, calories: 476.0, fiber: 3.0, iron: 3.5, calcium: 45.0, vitaminC: 0.0, saturedFat: 10.5, MUFA: 6.5, PUFA: 3.0, cholesterol: 15.0, sodium: 200.0)

    let foodItem60 = FoodItem(name: "Raspberries", code: FoodCode(rawValue: 8)!, carb: 12.0, protein: 1.2, fat: 0.7, servingSize: 150, calories: 64.5, fiber: 9.0, iron: 0.9, calcium: 37.5, vitaminC: 41.9, saturedFat: 0.03, MUFA: 0.05, PUFA: 0.37, cholesterol: 0.0, sodium: 0.0)

    let foodItem61 = FoodItem(name: "Honey", code: FoodCode(rawValue: 10)!, carb: 82.4, protein: 0.3, fat: 0.0, servingSize: 20, calories: 61.2, fiber: 0.2, iron: 0.1, calcium: 1.0, vitaminC: 0.5, saturedFat: 0.0, MUFA: 0.0, PUFA: 0.0, cholesterol: 0.0, sodium: 0.7)

    let foodItem62 = FoodItem(name: "Corn", code: FoodCode(rawValue: 9)!, carb: 19.0, protein: 3.2, fat: 1.2, servingSize: 200, calories: 86.0, fiber: 2.7, iron: 0.6, calcium: 5.0, vitaminC: 6.8, saturedFat: 0.2, MUFA: 0.3, PUFA: 0.6, cholesterol: 0.0, sodium: 16.0)

    let foodItem63 = FoodItem(name: "Feta Cheese", code: FoodCode(rawValue: 5)!, carb: 4.1, protein: 14.2, fat: 21.3, servingSize: 50, calories: 143.5, fiber: 0.0, iron: 0.2, calcium: 260.0, vitaminC: 0.0, saturedFat: 14.8, MUFA: 4.2, PUFA: 0.8, cholesterol: 89.5, sodium: 917.5)

    let foodItem64 = FoodItem(name: "Couscous", code: FoodCode(rawValue: 7)!, carb: 23.2, protein: 3.8, fat: 0.6, servingSize: 80, calories: 112.8, fiber: 1.4, iron: 0.5, calcium: 7.2, vitaminC: 0.0, saturedFat: 0.1, MUFA: 0.1, PUFA: 0.2, cholesterol: 0.0, sodium: 5.0)
    
    let foodItem65 = FoodItem(name: "Cake", code: FoodCode(rawValue: 10)!, carb: 50.0, protein: 5.0, fat: 15.0, servingSize: 80, calories: 375.0, fiber: 1.0, iron: 1.5, calcium: 20.0, vitaminC: 0.0, saturedFat: 6.0, MUFA: 6.0, PUFA: 2.0, cholesterol: 75.0, sodium: 300.0)

    let foodItem66 = FoodItem(name: "Ice Cream", code: FoodCode(rawValue: 10)!, carb: 23.6, protein: 3.5, fat: 11.0, servingSize: 100, calories: 207.0, fiber: 0.7, iron: 0.1, calcium: 128.0, vitaminC: 0.0, saturedFat: 6.8, MUFA: 2.8, PUFA: 0.5, cholesterol: 44.0, sodium: 80.0)

    let foodItem67 = FoodItem(name: "Cornflakes", code: FoodCode(rawValue: 7)!, carb: 84.0, protein: 8.0, fat: 0.4, servingSize: 30, calories: 112.2, fiber: 3.0, iron: 8.0, calcium: 2.0, vitaminC: 0.0, saturedFat: 0.1, MUFA: 0.1, PUFA: 0.2, cholesterol: 0.0, sodium: 300.0)
    
    let foodItem68 = FoodItem(name: "Pesto", code: FoodCode(rawValue: 10)!, carb: 4.0, protein: 4.5, fat: 50.0, servingSize: 20, calories: 200.0, fiber: 1.0, iron: 0.5, calcium: 70.0, vitaminC: 2.0, saturedFat: 6.0, MUFA: 28.0, PUFA: 16.0, cholesterol: 10.0, sodium: 700.0)

    let foodItem69 = FoodItem(name: "Parmesan Cheese", code: FoodCode(rawValue: 5)!, carb: 3.0, protein: 35.0, fat: 28.0, servingSize: 50, calories: 196.0, fiber: 0.0, iron: 0.9, calcium: 555.0, vitaminC: 0.0, saturedFat: 18.0, MUFA: 8.0, PUFA: 1.0, cholesterol: 68.0, sodium: 800.0)
    
    let foodItem70 = FoodItem(name: "Turkey Breast", code: FoodCode(rawValue: 2)!, carb: 0.0, protein: 29.0, fat: 1.0, servingSize: 100, calories: 135.0, fiber: 0.0, iron: 1.0, calcium: 10.0, vitaminC: 0.0, saturedFat: 0.3, MUFA: 0.2, PUFA: 0.4, cholesterol: 50.0, sodium: 48.0)




    
    context.insert(foodItem1)
    context.insert(foodItem2)
    context.insert(foodItem3)
    context.insert(foodItem4)
    context.insert(foodItem5)
    context.insert(foodItem6)
    context.insert(foodItem7)
    context.insert(foodItem8)
    context.insert(foodItem9)
    context.insert(foodItem10)
    context.insert(foodItem11)
    context.insert(foodItem12)
    context.insert(foodItem13)
    context.insert(foodItem14)
    context.insert(foodItem15)
    context.insert(foodItem16)
    context.insert(foodItem17)
    context.insert(foodItem18)
    context.insert(foodItem19)
    context.insert(foodItem20)
    context.insert(foodItem21)
    context.insert(foodItem22)
    context.insert(foodItem23)
    context.insert(foodItem24)
    context.insert(foodItem25)
    context.insert(foodItem26)
    context.insert(foodItem27)
    context.insert(foodItem28)
    context.insert(foodItem29)
    context.insert(foodItem30)
    context.insert(foodItem31)
    context.insert(foodItem32)
    context.insert(foodItem33)
    context.insert(foodItem34)
    context.insert(foodItem35)
    context.insert(foodItem36)
    context.insert(foodItem37)
    context.insert(foodItem38)
    context.insert(foodItem39)
    context.insert(foodItem40)
    context.insert(foodItem41)
    context.insert(foodItem42)
    context.insert(foodItem43)
    context.insert(foodItem44)
    context.insert(foodItem45)
    context.insert(foodItem46)
    context.insert(foodItem47)
    context.insert(foodItem48)
    context.insert(foodItem49)
    context.insert(foodItem50)
    context.insert(foodItem51)
    context.insert(foodItem52)
    context.insert(foodItem53)
    context.insert(foodItem54)
    context.insert(foodItem55)
    context.insert(foodItem56)
    context.insert(foodItem57)
    context.insert(foodItem58)
    context.insert(foodItem59)
    context.insert(foodItem60)
    context.insert(foodItem61)
    context.insert(foodItem62)
    context.insert(foodItem63)
    context.insert(foodItem64)
    context.insert(foodItem65)
    context.insert(foodItem66)
    context.insert(foodItem67)
    context.insert(foodItem68)
    context.insert(foodItem69)
    context.insert(foodItem70)
}
