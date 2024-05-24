//
//  Ranges.swift
//  BACCO
//
//  Created by GIF on 10/05/24.
//


import Foundation
import SwiftData


struct PhysiologicalRangeValue: Codable {
    var min: Double
    var max: Double
}


enum PhysiologicalRange: Codable, Identifiable, CaseIterable {
    case sdnn_physiological, rmssd_physiological
    
    var id: Self { self }
    
    func value(forAge ageRange: AgeRange, andSex sesso: Sesso) -> PhysiologicalRangeValue {
        switch (self, sesso, ageRange) {
        case (.sdnn_physiological, .Maschio, .age_16_20):
            return PhysiologicalRangeValue(min: 17.80, max: 190.90)
        case (.sdnn_physiological, .Maschio, .age_20_30):
            return PhysiologicalRangeValue(min: 13.90, max: 161.40)
        case (.sdnn_physiological, .Maschio, .age_30_40):
            return PhysiologicalRangeValue(min: 17.80, max: 129.20)
        case (.sdnn_physiological, .Maschio, .age_40_50):
            return PhysiologicalRangeValue(min: 8.80, max: 113.70)
        case (.sdnn_physiological, .Maschio, .age_50_60):
            return PhysiologicalRangeValue(min: 6.90, max: 103.40)
        case (.sdnn_physiological, .Maschio, .age_60_70):
            return PhysiologicalRangeValue(min: 5.60, max: 104.80)
        case (.sdnn_physiological, .Maschio, .age_70_80):
            return PhysiologicalRangeValue(min: 4.70, max: 120.90)
        case (.sdnn_physiological, .Maschio, .age_80_up):
            return PhysiologicalRangeValue(min: 3.90, max: 158.30)
            
        case (.sdnn_physiological, .Femmina, .age_16_20):
            return PhysiologicalRangeValue(min: 20.00, max: 199.20)
        case (.sdnn_physiological, .Femmina, .age_20_30):
            return PhysiologicalRangeValue(min: 16.60, max: 172.70)
        case (.sdnn_physiological, .Femmina, .age_30_40):
            return PhysiologicalRangeValue(min: 13.30, max: 137.80)
        case (.sdnn_physiological, .Femmina, .age_40_50):
            return PhysiologicalRangeValue(min: 10.60, max: 109.50)
        case (.sdnn_physiological, .Femmina, .age_50_60):
            return PhysiologicalRangeValue(min: 8.40, max: 90.20)
        case (.sdnn_physiological, .Femmina, .age_60_70):
            return PhysiologicalRangeValue(min: 6.90, max: 82.80)
        case (.sdnn_physiological, .Femmina, .age_70_80):
            return PhysiologicalRangeValue(min: 5.90, max: 89.50)
        case (.sdnn_physiological, .Femmina, .age_80_up):
            return PhysiologicalRangeValue(min: 5.10, max: 126.10)
            
        case (.rmssd_physiological, .Maschio, .age_16_20):
            return PhysiologicalRangeValue(min: 21.60, max: 239.30)
        case (.rmssd_physiological, .Maschio, .age_20_30):
            return PhysiologicalRangeValue(min: 16.00, max: 182.70)
        case (.rmssd_physiological, .Maschio, .age_30_40):
            return PhysiologicalRangeValue(min: 12.10, max: 134.40)
        case (.rmssd_physiological, .Maschio, .age_40_50):
            return PhysiologicalRangeValue(min: 9.80, max: 111.50)
        case (.rmssd_physiological, .Maschio, .age_50_60):
            return PhysiologicalRangeValue(min: 7.70, max: 102.50)
        case (.rmssd_physiological, .Maschio, .age_60_70):
            return PhysiologicalRangeValue(min: 6.20, max: 114.60)
        case (.rmssd_physiological, .Maschio, .age_70_80):
            return PhysiologicalRangeValue(min: 5.40, max: 157.10)
        case (.rmssd_physiological, .Maschio, .age_80_up):
            return PhysiologicalRangeValue(min: 4.90, max: 230.10)
            
        case (.rmssd_physiological, .Femmina, .age_16_20):
            return PhysiologicalRangeValue(min: 25.30, max: 261.80)
        case (.rmssd_physiological, .Femmina, .age_20_30):
            return PhysiologicalRangeValue(min: 19.80, max: 212.90)
        case (.rmssd_physiological, .Femmina, .age_30_40):
            return PhysiologicalRangeValue(min: 15.30, max: 158.40)
        case (.rmssd_physiological, .Femmina, .age_40_50):
            return PhysiologicalRangeValue(min: 12.10, max: 118.50)
        case (.rmssd_physiological, .Femmina, .age_50_60):
            return PhysiologicalRangeValue(min: 9.50, max: 95.60)
        case (.rmssd_physiological, .Femmina, .age_60_70):
            return PhysiologicalRangeValue(min: 8.00, max: 92.20)
        case (.rmssd_physiological, .Femmina, .age_70_80):
            return PhysiologicalRangeValue(min: 7.00, max: 112.10)
        case (.rmssd_physiological, .Femmina, .age_80_up):
            return PhysiologicalRangeValue(min: 6.30, max: 166.70)
        }
    }

}


enum AdequateIntake: Codable, Identifiable, CaseIterable {
    case iron, calcium, vitaminC
    
    var id: Self { self }

    func value(forAge ageRange: AgeRange, andSex sesso: Sesso) -> Double {
        switch (self, sesso, ageRange) {
        
        // IRON
        case (.iron, .Maschio, .age_16_20):
            return 11.0
        case (.iron, .Maschio, .age_20_30),
            (.iron, .Maschio, .age_30_40),
            (.iron, .Maschio, .age_40_50),
            (.iron, .Maschio, .age_50_60),
            (.iron, .Maschio, .age_60_70),
            (.iron, .Maschio, .age_70_80),
            (.iron, .Maschio, .age_80_up):
            return 8.0
        
        case (.iron, .Femmina, .age_16_20):
            return 15.0
        case (.iron, .Femmina, .age_20_30),
            (.iron, .Femmina, .age_30_40),
            (.iron, .Femmina, .age_40_50):
            return 18.0
        case (.iron, .Femmina, .age_50_60),
            (.iron, .Femmina, .age_60_70),
            (.iron, .Femmina, .age_70_80),
            (.iron, .Femmina, .age_80_up):
            return 8.0
        
        // CALCIUM
        case (.calcium, .Maschio, .age_16_20):
            return 1300.0
        case (.calcium, .Maschio, .age_20_30),
            (.calcium, .Maschio, .age_30_40),
            (.calcium, .Maschio, .age_40_50),
            (.calcium, .Maschio, .age_50_60),
            (.calcium, .Maschio, .age_60_70):
            return 1000.0
        case (.calcium, .Maschio, .age_70_80),
            (.calcium, .Maschio, .age_80_up):
            return 1200.0
            
        case (.calcium, .Femmina, .age_16_20):
            return 1300.0
        case (.calcium, .Femmina, .age_20_30),
            (.calcium, .Femmina, .age_30_40),
            (.calcium, .Femmina, .age_40_50),
            (.calcium, .Femmina, .age_50_60),
            (.calcium, .Femmina, .age_60_70):
            return 1000.0
        case (.calcium, .Femmina, .age_70_80),
            (.calcium, .Femmina, .age_80_up):
            return 1200.0

        // VITAMIN C
        case (.vitaminC, .Maschio, .age_16_20):
            return 75.0
        case (.vitaminC, .Maschio, .age_20_30),
            (.vitaminC, .Maschio, .age_30_40),
            (.vitaminC, .Maschio, .age_40_50),
            (.vitaminC, .Maschio, .age_50_60),
            (.vitaminC, .Maschio, .age_60_70),
            (.vitaminC, .Maschio, .age_70_80),
            (.vitaminC, .Maschio, .age_80_up):
            return 90.0

        case (.vitaminC, .Femmina, .age_16_20):
            return 65.0
        case (.vitaminC, .Femmina, .age_20_30),
            (.vitaminC, .Femmina, .age_30_40),
            (.vitaminC, .Femmina, .age_40_50),
            (.vitaminC, .Femmina, .age_50_60),
            (.vitaminC, .Femmina, .age_60_70),
            (.vitaminC, .Femmina, .age_70_80),
            (.vitaminC, .Femmina, .age_80_up):
            return 75.0
        }
    }
}

// FUNCTION TO DETERMINE ADEQUATE INTAKES
// extension User {
//     func updateAdequateIntakeNew() {
//         adequateIntake = {
//             var intakeValuesNew = [AdequateIntake: Double]()
//             for nutrient in AdequateIntake.allCases {
//                 intakeValues[nutrient] = nutrient.value(forAge: ageRangeNew, andSex: sesso)
//             }
//             return intakeValues
//         }()
//     }
// }


// FUNCTION TO DETERMINE AGE RANGE
// extension User {
//     func updateAgeRangeNew() {
//         ageRangeNew = {
//             switch age {
//             case 16...19:
//                 return .age_16_20
//             case 20...29:
//                 return .age_20_30
//             case 30...39:
//                 return .age_30_40
//             case 40...49:
//                 return .age_40_50
//             case 50...59:
//                 return .age_50_60
//             case 60...69:
//                 return .age_60_70
//             case 70...79:
//                 return .age_70_80
//             case 78...:
//                 return .age_80_up
//             default:
//                 fatalError("Invalid age") // Consider handling unexpected ages more gracefully
//             }
//         }()
//     }
// }


// FUNCTION TO DETERMINE PHYSIOLOGICAL RANGE
// extension User {
//     func updatePhysiologicalRange() {
//         physiologicalRange = {
//             var newRanges = [PhysiologicalRange: (Double, Double)]()
//             for physiologicalParameter in PhysiologicalRange.allCases {
//                 newRanges[physiologicalParameter] = physiologicalParameter.value(forAge: ageRangeNew, andSex: sesso)
//             }
//             return newRanges
//         }()
//     }
// }
