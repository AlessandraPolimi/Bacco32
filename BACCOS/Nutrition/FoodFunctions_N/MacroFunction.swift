//
//  MacroFunction.swift
//  BACCO
//
//  Created by GIF on 10/05/24.
//

// MACRO FUNCTION
import SwiftData
import Foundation

//
//
// FUNZIONE INDICE MACRONUTRIENTI
//
//

func MacronutrientsIndexFunction (context: ModelContext, todayDailyFoodTotal: DailyFoodTotal) -> Double {
    guard let dbUser = try? context.fetch(FetchDescriptor<User>()), let user = dbUser.first else {
            print("Error: Unable to fetch user data")
            return 0.0
        }
    
    // Inizializza punteggi
    var carbScore = 0.0
    var proteinScore = 0.0
    var fatScore = 0.0
   
    //
    // Carb Target
    //
    
    if let carbTarget = dbUser.first?.carbTarget {
        carbScore = (todayDailyFoodTotal.carbTotal) * (100 / carbTarget)
        
        if carbScore > 100 {
            carbScore = 200 - carbScore
            if carbScore < 0 {
                carbScore = 0
            }
        }
        
    } else {
        print("Error: no values inserted")
    }
    
    //
    // Protein Target
    //
    
    if let proteinTarget = dbUser.first?.proteinTarget {
        proteinScore = todayDailyFoodTotal.proteinTotal * (100 / proteinTarget)
        
        if proteinScore > 100 {
            proteinScore = 200 - proteinScore
            if proteinScore < 0 {
                proteinScore = 0
            }
        }
        
    } else {
        print("Error: no values inserted")
    }
    
    //
    // Fat Target
    //
    
    if let fatTarget = dbUser.first?.fatTarget {
        fatScore = todayDailyFoodTotal.fatTotal * (100 / fatTarget)
        if fatScore > 100 {
            fatScore = 200 - fatScore
            if fatScore < 0 {
                fatScore = 0
            }
        }
        
    } else {
        print("Error: no values inserted")
    }
    
    var MacronutrientsIndex = 0.0
    if carbScore >= 0 && proteinScore >= 0 && fatScore >= 0 {
        MacronutrientsIndex = (carbScore + proteinScore + fatScore) / 3
        
    } else {
        print("Error: one ore more values missing")
    }
    return MacronutrientsIndex
}



















/*
func MacronutrientsIndexFunction (context: ModelContext, todayDailyFoodTotal: DailyFoodTotal) -> Double {
    
    let dbUser = try! context.fetch(FetchDescriptor<User>())
    
    var carbScore = 0.0
    var proteinScore = 0.0
    var fatScore = 0.0
   
    if let carbTarget = dbUser.first?.carbTarget {
        carbScore = (todayDailyFoodTotal.carbTotal) * (100 / carbTarget)
        if carbScore > 100 {
            carbScore = 200 - carbScore
        }
    } else {
        print("Error: no values inserted")
    }
    
    if let proteinTarget = dbUser.first?.proteinTarget {
        proteinScore = (todayDailyFoodTotal.proteinTotal) * (100 / proteinTarget)
        if proteinScore > 100 {
            proteinScore = 200 - proteinScore
        }
    } else {
        print("Error: no values inserted")
    }
    
    if let fatTarget = dbUser.first?.fatTarget {
        fatScore = (todayDailyFoodTotal.fatTotal) * (100 / fatTarget)
        if fatScore > 100 {
            fatScore = 200 - fatScore
        }
    } else {
        print("Error: no values inserted")
    }
    
    var MacronutrientsIndex = 0.0
    if carbScore >= 0 && proteinScore >= 0 && fatScore >= 0 {
        MacronutrientsIndex = (carbScore + proteinScore + fatScore) / 3
        //newNutritionIndex.MacronutrientsIndex = (carbScore + proteinScore + fatScore) / 3
        // context.insert(newMacronutrientsIndex)
    } else {
        print("Error: one or more values missing")
    }
    
    return MacronutrientsIndex
}
*/
