//
//  personal_data.swift
//  BACCO
//
//  Created by GIF on 10/05/24.
//


// PERSONAL DATA
import Foundation
import SwiftData

@Model
class User : CustomStringConvertible, Identifiable {
    var id = UUID()
    var name: String
    var age: Int
    var height: Double
    var weight: Double
    var sesso: Sesso
    var lpa: LivelloPA
    
    var caloricRange: CaloricRange
    var ageRange: AgeRange
    var adequateIntake: [AdequateIntake: Double]
    var physiologicalRange: [PhysiologicalRange: PhysiologicalRangeValue]
    
    
    
    var BMR = 0.0
    var MHR = 0
    var carbTarget = 0.0
    var proteinTarget = 0.0
    var fatTarget = 0.0
    
    var description: String {
        return "Personal(name: \(name), age: \(age), sesso: \(sesso), livelloPA: \(lpa), caloricRange: \(caloricRange)"
    }
    
    init(name: String, age: Int, height: Double, weight: Double, sesso: Sesso, lpa: LivelloPA, caloricRange: CaloricRange = .range1, ageRange: AgeRange = .age_16_20, adequateIntake: [AdequateIntake: Double] = [.calcium : 0.0, .iron : 0.0, .vitaminC : 0.0], physiologicalRange: [PhysiologicalRange: PhysiologicalRangeValue] = [:], BMR: Double = 0.0, MHR: Int = 0, carbTarget: Double = 0.0, proteinTarget: Double = 0.0, fatTarget: Double = 0.0) {
        self.name = name
        self.age = age
        self.height = height
        self.weight = weight
        self.sesso = sesso
        self.lpa = lpa
        self.caloricRange = caloricRange
        self.ageRange = ageRange
        self.adequateIntake = adequateIntake
        self.physiologicalRange = physiologicalRange
        self.BMR = BMR
        self.MHR = MHR
        self.carbTarget = carbTarget
        self.proteinTarget = proteinTarget
        self.fatTarget = fatTarget
    }
}
        

// self.updateAgeRange()
// self.updateAdequateIntake()

enum Sesso: String /*il tipo metteva int anche se era una stringa*/, Codable, Identifiable, CaseIterable {
case Maschio,Femmina
    var id: Self { self}
    
    var descr: String{
        switch self {
        case.Femmina:
            "Female"
        case.Maschio:
            "Male"
        }
    }
}

enum LivelloPA: String /*il tipo metteva int anche se era una stringa*/, Codable, Identifiable, CaseIterable {
case Sedentary, LowPA, ModeratePA, HighPA, ExtraPA
    var id: Self { self}
    
    var descr: String{
        switch self {
        case.ExtraPA:
            "ExtraPAL"
        case.HighPA:
            "HighPAL"
        case.ModeratePA:
            "ModeratePAL"
        case.LowPA:
            "LowPAL"
        case.Sedentary:
            "Sedentary"
        }
    }
}

enum CaloricRange: Codable, Identifiable, CaseIterable {
    case range1, range2, range3
    var id: Self { self }
    
    var maxServingVegetables: Double {
        switch self {
        case .range1:
            return 3.0
        case .range2:
            return 4.0
        case .range3:
            return 5.0
        }
    }
    
    var maxServingFruit: Double {
        switch self {
        case .range1:
            return 2.0
        case .range2:
            return 3.0
        case .range3:
            return 4.0
        }
    }
    
    var maxServingGrain: Double {
        switch self {
        case .range1:
            return 6.0
        case .range2:
            return 8.5
        case .range3:
            return 11.0
        }
    }
    
    var maxServingFiber: Double {
        switch self {
        case .range1:
            return 20.0
        case .range2:
            return 25.0
        case .range3:
            return 30.0
        }
    }
}


// FUNCTION TO DETERMINE CALORIC RANGE
extension User {
    func updateCaloricRange() {
        if BMR <= 1700 {
            // caloricRange is already initialized to .range1, so do nothing if BMR is 1700 or less
        } else if BMR > 1700 && BMR < 2200 {
            caloricRange = .range2
        } else {
            caloricRange = .range3
        }
    }
}

// FUNCTION TO DETERMINE AGE RANGE
 extension User {
     func updateAgeRange() {
         ageRange = {
             switch age {
             case 16...19:
                 return .age_16_20
             case 20...29:
                 return .age_20_30
             case 30...39:
                 return .age_30_40
             case 40...49:
                 return .age_40_50
             case 50...59:
                 return .age_50_60
             case 60...69:
                 return .age_60_70
             case 70...79:
                 return .age_70_80
             case 78...:
                 return .age_80_up
             default:
                 return .age_16_20
                 // fatalError("Invalid age") // Consider handling unexpected ages more gracefully
             }
         }()
     }
 }

enum AgeRange: Codable, CaseIterable {
    case age_16_20, age_20_30, age_30_40, age_40_50, age_50_60,age_60_70, age_70_80, age_80_up
}


// FUNCTION TO DETERMINE ADEQUATE INTAKES
extension User {
    func updateAdequateIntake() {
        adequateIntake = {
            var intakeValues = [AdequateIntake: Double]()
            for nutrient in AdequateIntake.allCases {
                intakeValues[nutrient] = nutrient.value(forAge: ageRange, andSex: sesso)
            }
            return intakeValues
        }()
    }
}


// FUNCTION TO DETERMINE PHYSIOLOGICAL RANGE
extension User {
    func updatePhysiologicalRange() {
        physiologicalRange = {
            var newRanges = [PhysiologicalRange: PhysiologicalRangeValue]()
            for physiologicalParameter in PhysiologicalRange.allCases {
                newRanges[physiologicalParameter] = physiologicalParameter.value(forAge: ageRange, andSex: sesso)
            }
            return newRanges
        }()
    }
}



// FUNZIONE CALCOLO REFERENCE VALUES
//
//

func ReferenceValuesFunction (context: ModelContext){
    let dbUser = try! context.fetch(FetchDescriptor<User>())
    
    for user in dbUser{
        var bmr = user.BMR
        let heightM = user.height / 100;
        
        // Calculate BMR using Harris-Benedict equation based on sex
        switch user.sesso {
        case .Maschio: bmr = 9.65 * user.weight + 573 * heightM - 5.08 * Double(user.age) + 260
        case .Femmina: bmr = 7.38 * user.weight + 607 * heightM - 2.31 * Double(user.age) + 43
        }
        
        // Adjust BMR based on activity level and calculate protein and carb target
        var protein = 1.0               // recommened quantity of protein and carbs is calculated as g per kg of BW
        var carb = 1.0                  // different adequate level are set depending on PA
        
        switch user.lpa {
        case .Sedentary:
            bmr *= 1.2
            protein *= 0.8 * user.weight
            carb *= 3 * user.weight
        case .LowPA:
            bmr *= 1.375
            protein *= 1.0 * user.weight
            carb *= 4 * user.weight
        case .ModeratePA:
            bmr *= 1.55
            protein *= 1.50 * user.weight
            carb *= 5 * user.weight
        case .HighPA:
            bmr *= 1.725
            protein *= 1.6 * user.weight
            carb *= 6 * user.weight
        case .ExtraPA:
            bmr *= 1.9
            protein *= 1.8 * user.weight
            carb *= 8 * user.weight
        }
        
        // calculate fat as remaining TDEE percentage
        var fat = (bmr - (protein * 4) - (carb * 4)) / 9.0

        // Calculate total calories
        let totalCalories = bmr

        // Check if fat < 0.0
        if fat < 0.0 {
            print("sono entrato nel primo if")
            // Set fat to 15% of total calories
            let targetCaloriesFromFat = totalCalories * 0.15
            fat = targetCaloriesFromFat / 9
            
            // Calculate the remaining calories after setting fat
            let remainingCalories = totalCalories - targetCaloriesFromFat
            
            // Calculate the sum of protein and carb calories
            let sumProteinCarbCalories = (protein * 4) + (carb * 4)
            
            // Calculate the adjustment factor
            let adjustmentFactor = remainingCalories / sumProteinCarbCalories
            
            // Adjust protein and carb proportionally
            protein *= adjustmentFactor
            carb *= adjustmentFactor
            
        } else {
            print("sono entrato nel else")
            
            // Ensure fat percentage is within the range of 15-30%
            let fatPercentage = (fat * 9) / totalCalories
            print("fatPercentage: \(fatPercentage)")
            
            if fatPercentage < 0.15 {
                print("sono entrato nel fatPercentage < 0.15")
                print("total calories \(totalCalories)")
                // Increase protein and carbs proportionally to decrease fat percentage
                let targetCaloriesFromFat = totalCalories * 0.15
                fat = targetCaloriesFromFat / 9
                let currentCaloriesFromFat = fat * 9
                let difference = targetCaloriesFromFat - currentCaloriesFromFat
                let adjustmentFactor = difference / (protein * 4 + carb * 4)
                
                protein += protein * adjustmentFactor
                carb += carb * adjustmentFactor
                
            } else if fatPercentage > 0.30 {
                print("sono entrato in else if")
                // Decrease protein and carbs proportionally to increase fat percentage
                let targetCaloriesFromFat = totalCalories * 0.30
                fat = targetCaloriesFromFat / 9
                let currentCaloriesFromFat = fat * 9
                let difference = currentCaloriesFromFat - targetCaloriesFromFat
                let adjustmentFactor = difference / (protein * 4 + carb * 4)
                
                protein -= protein * adjustmentFactor
                carb -= carb * adjustmentFactor
                
            }
            
            // Ensure fat is not below zero
            if fat < 0 {
                print("sono entrato nel fat < 0")
                fat = 0
            }
        }

        
        // Output the macronutrients
        print("Protein: \(protein) grams")
        print("Carbs: \(carb) grams")
        print("Fat: \(fat) grams")

        
        // assegnazione valori all'utente e salvataggio in memoria
        user.MHR = 208 - user.age*7/10
        user.BMR = bmr
        user.carbTarget = carb
        user.proteinTarget = protein
        user.fatTarget = fat
        user.updateCaloricRange()
        user.updateAgeRange()
        user.updateAdequateIntake()
        user.updatePhysiologicalRange()
        
        context.insert(user)
    }
}
