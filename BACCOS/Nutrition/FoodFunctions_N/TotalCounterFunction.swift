//
//  TotalCounterFunction.swift
//  BACCO
//
//  Created by GIF on 10/05/24.
//

// TOTAL COUNTER FUNCTION
import Foundation
import SwiftData

let calendar = Calendar.current

class DailyFoodTotal {
    var carbTotal = 0.0
    var proteinTotal = 0.0
    var fatTotal = 0.0
    var date = Date()
    
    var fiberTotal = 0.0
    var ironTotal = 0.0
    var calciumTotal = 0.0
    var vitaminCTotal = 0.0
    var saturedFatTotal = 0.0
    var MUFATotal = 0.0 // monoinsaturi
    var PUFATotal = 0.0 // polinsaturi
    var cholesterolTotal = 0.0
    var sodiumTotal = 0.0
    var caloriesTotal = 0.0
    var emptyCalories = 0.0
    
    // serving sizes e groups
    var servingSizes: ServingSizes = ServingSizes()
    var variety1: Variety1 = Variety1()
    var variety2: Variety2 = Variety2()
    
    init(carbTotal: Double = 0.0, proteinTotal: Double = 0.0, fatTotal: Double = 0.0, date: Date = Date(), fiberTotal: Double = 0.0, ironTotal: Double = 0.0, calciumTotal: Double = 0.0, vitaminCTotal: Double = 0.0, saturedFatTotal: Double = 0.0, MUFATotal: Double = 0.0, PUFATotal: Double = 0.0, cholesterolTotal: Double = 0.0, sodiumTotal: Double = 0.0, caloriesTotal: Double = 0.0, emptyCalories: Double = 0.0, servingSizes: ServingSizes, variety1: Variety1, variety2: Variety2) {
        self.carbTotal = carbTotal
        self.proteinTotal = proteinTotal
        self.fatTotal = fatTotal
        self.date = date
        self.fiberTotal = fiberTotal
        self.ironTotal = ironTotal
        self.calciumTotal = calciumTotal
        self.vitaminCTotal = vitaminCTotal
        self.saturedFatTotal = saturedFatTotal
        self.MUFATotal = MUFATotal
        self.PUFATotal = PUFATotal
        self.cholesterolTotal = cholesterolTotal
        self.sodiumTotal = sodiumTotal
        self.caloriesTotal = caloriesTotal
        self.emptyCalories = emptyCalories
        self.servingSizes = servingSizes
        self.variety1 = variety1
        self.variety2 = variety2
    }
}



// definizione struct per DailyFoodTotalTest
struct ServingSizes: Codable, Hashable {
    var servingsVegetables = 0.0
    var servingsFruits = 0.0
    var servingsGrains = 0.0
}

struct Variety1: Codable, Hashable {
    var group1 = 0          // group 1: meat/poultry/fish/eggs
    var group2 = 0          // group 2: dairy/beans
    var group3 = 0          // group 3: grain
    var group4 = 0          // group 4: fruit
    var group5 = 0          // group 5: vegetable
}

struct Variety2: Codable, Hashable {
    var meat = 0
    var poultry = 0
    var fish = 0
    var dairy = 0
    var beans = 0
    var egg = 0
}


extension DailyFoodTotal {
    func sumVariety1Groups() -> Int {
        return variety1.group1 +
               variety1.group2 +
               variety1.group3 +
               variety1.group4 +
               variety1.group5
    }
}

extension DailyFoodTotal {
    func sumProteinSources() -> Int {
        return variety2.meat +
               variety2.poultry +
               variety2.fish +
               variety2.dairy +
               variety2.beans +
               variety2.egg
    }
}



func TotalCounterFunction (context: ModelContext) -> DailyFoodTotal {
    
    let newDailyFoodTotal = DailyFoodTotal(servingSizes: ServingSizes(), variety1: Variety1(), variety2: Variety2())
    
    // valutare di mettere un do catch
    let dbFoodItem = try! context.fetch(FetchDescriptor<FoodItem>())
    let dbAddedFood = try! context.fetch(FetchDescriptor<AddedFood>())
    // let dbDailyFoodTotalTest = try! context.fetch(FetchDescriptor<DailyFoodTotalTest>())
    
    for addedFood in dbAddedFood {
        for foodItem in dbFoodItem {
            
                if addedFood.name.lowercased() == foodItem.name.lowercased() {
                newDailyFoodTotal.carbTotal += foodItem.carb * (addedFood.grams / 100)
                newDailyFoodTotal.proteinTotal += foodItem.protein * (addedFood.grams / 100)
                newDailyFoodTotal.fatTotal += foodItem.fat * (addedFood.grams / 100)
                newDailyFoodTotal.fiberTotal += foodItem.fiber * (addedFood.grams / 100)
                newDailyFoodTotal.ironTotal += foodItem.iron * (addedFood.grams / 100)
                newDailyFoodTotal.calciumTotal += foodItem.calcium * (addedFood.grams / 100)
                newDailyFoodTotal.vitaminCTotal += foodItem.vitaminC * (addedFood.grams / 100)
                newDailyFoodTotal.saturedFatTotal += foodItem.saturedFat * (addedFood.grams / 100)
                newDailyFoodTotal.MUFATotal += foodItem.MUFA * (addedFood.grams / 100)
                newDailyFoodTotal.PUFATotal += foodItem.PUFA * (addedFood.grams / 100)
                newDailyFoodTotal.cholesterolTotal += foodItem.cholesterol * (addedFood.grams / 100)
                newDailyFoodTotal.sodiumTotal += foodItem.sodium * (addedFood.grams / 100)
                newDailyFoodTotal.caloriesTotal += foodItem.calories
                
                // salvo il codice dell'alimento
                let code = foodItem.code
                // calcolo le frequenze controllando i codici
                switch code {
                case .meat:
                    newDailyFoodTotal.variety1.group1 += 1
                    newDailyFoodTotal.variety2.meat += 1
                case .poultry:
                    newDailyFoodTotal.variety1.group1 += 1
                    newDailyFoodTotal.variety2.poultry += 1
                case .fish:
                    newDailyFoodTotal.variety1.group1 += 1
                    newDailyFoodTotal.variety2.fish += 1
                case .egg:
                    newDailyFoodTotal.variety1.group1 += 1
                    newDailyFoodTotal.variety2.egg += 1
                case .dairy:
                    newDailyFoodTotal.variety1.group2 += 1
                    newDailyFoodTotal.variety2.dairy += 1
                case .beans:
                    newDailyFoodTotal.variety1.group2 += 1
                    newDailyFoodTotal.variety2.beans += 1
                case .grain:
                    newDailyFoodTotal.variety1.group3 += 1
                    newDailyFoodTotal.servingSizes.servingsGrains += addedFood.grams / foodItem.servingSize
                case .fruit:
                    newDailyFoodTotal.variety1.group4 += 1
                    newDailyFoodTotal.servingSizes.servingsFruits += addedFood.grams / foodItem.servingSize
                case .vegetable:
                    newDailyFoodTotal.variety1.group5 += 1
                    newDailyFoodTotal.servingSizes.servingsVegetables += addedFood.grams / foodItem.servingSize
                case .emptyCalories:
                    newDailyFoodTotal.emptyCalories += foodItem.calories
                }
            }
        }
    }
    return newDailyFoodTotal
}
