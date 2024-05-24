//
//  FunctionDQI.swift
//  BACCO
//
//  Created by GIF on 10/05/24.
//

// FUNCTON DQI
import Foundation
import SwiftData

    
func DQICalculatorFunction (context: ModelContext, todayDailyFoodTotal: DailyFoodTotal) -> Double {
    
    let dbUser = try! context.fetch(FetchDescriptor<User>())
    let user = dbUser.first!
    
    //
    //
    // VARIETY 0-20 points
    //
    //
    
    // Overall food group variety 0-15 points
    var varietyScore1 = 15
    let freq = todayDailyFoodTotal.sumVariety1Groups()
    if freq == 4 {
        varietyScore1 = 12
    } else if freq == 3 {
        varietyScore1 = 9
    } else if freq == 2 {
        varietyScore1 = 6
    } else if freq == 1 {
        varietyScore1 = 3
    } else if freq == 0 {
        varietyScore1 = 0
    }
    // print("varietyScore1: \(varietyScore1)")
    
    // Within-group variety for protein source 0-5 points
    var varietyScore2 = 0
    let counterProtein = todayDailyFoodTotal.sumProteinSources()
    
    if counterProtein >= 3 {
        varietyScore2 = 5
    } else if counterProtein == 2 {
        varietyScore2 = 3
    } else if counterProtein == 1 {
        varietyScore2 = 1
    }
    // print("varietyScore2: \(varietyScore2)")
    
    let varietyScore = varietyScore1 + varietyScore2
    // print("varietyScore: \(varietyScore)")
    
    //
    //
    // ADEQUACY 0-40 points
    //
    //
    
    //let userCaloricRange = DetermineCaloricRange(user: dbUser.first!)
    let maxServingVegetables = user.caloricRange.maxServingVegetables
    let maxServingFruit = user.caloricRange.maxServingFruit
    let maxServingGrain = user.caloricRange.maxServingGrain
    let maxServingFiber = user.caloricRange.maxServingFiber
    
    // Adequacy score - VEGETABLES GROUP 0-5 points
    var VegetableGroupPoints = 0.0
    if todayDailyFoodTotal.servingSizes.servingsVegetables >= maxServingVegetables {
        VegetableGroupPoints = 5.0
    } else {
        VegetableGroupPoints = (5 * todayDailyFoodTotal.servingSizes.servingsVegetables) / maxServingVegetables
    }
   // print("VegetableGroupPoints: \(VegetableGroupPoints)")
    
    // Adequacy score - FRUIT GROUP 0-5 points
    var FruitGroupPoints = 0.0
    if todayDailyFoodTotal.servingSizes.servingsFruits >= maxServingFruit {
        FruitGroupPoints = 5.0
    } else {
        FruitGroupPoints = (5 * todayDailyFoodTotal.servingSizes.servingsFruits) / maxServingFruit
    }
    // print("FruitGroupPoints: \(FruitGroupPoints)")
    
    // Adequacy score - GRAIN GROUP 0-5 points
    var GrainGroupPoints = 0.0
    if todayDailyFoodTotal.servingSizes.servingsGrains >= maxServingGrain {
        GrainGroupPoints = 5.0
    } else {
        GrainGroupPoints = (5 * todayDailyFoodTotal.servingSizes.servingsGrains) / maxServingGrain
    }
    // print("GrainGroupPoints: \(GrainGroupPoints)")
    
    // Adequacy score - FIBER 0-5 points
    var FiberPoints = 0.0
    if todayDailyFoodTotal.fiberTotal >= maxServingFiber {
        FiberPoints = 5.0
    } else {
        FiberPoints = (5 * (todayDailyFoodTotal.fiberTotal) / maxServingFiber)
    }
    // print("FiberPoints: \(FiberPoints)")
    
    // Adequacy score - PROTEIN 0-5 points
    // proteinPercentage calcola percentuale apporto calorico dovuto alle proteine rispetto all'apporto calorico totale del giorno
    let caloriesTotal = todayDailyFoodTotal.caloriesTotal
    var ProteinPoints = 0.0
    let proteinPercentage = (todayDailyFoodTotal.proteinTotal * 4 * 100) / caloriesTotal
    if proteinPercentage >= 10 {
        ProteinPoints = 5.0
    } else {
        ProteinPoints = (5 * proteinPercentage) / 10
    }
    //print("ProteinPoints: \(ProteinPoints)")
    
    // Adequacy score - IRON 0-5 points
    var IronPoints = 0.0
     if let ironAI = user.adequateIntake[.iron] {
         let ironPercentage = (todayDailyFoodTotal.ironTotal / ironAI) * 100
         if ironPercentage >= 100 {
             IronPoints = 5.0
         } else {
             IronPoints = (ironPercentage / 100) * 5.0
         }
     } else {
      //   print("Iron intake or total is not available.")
     }
   // print("IronPoints: \(IronPoints)")
    
    // Adequacy score - CALCIUM 0-5 points
    var CalciumPoints = 0.0
     if let calciumAI = user.adequateIntake[.calcium] {
         let calciumPercentage = (todayDailyFoodTotal.calciumTotal / calciumAI) * 100
         if calciumPercentage >= 100 {
             CalciumPoints = 5.0
         } else {
             CalciumPoints = (calciumPercentage / 100) * 5.0
         }
     } else {
         print("Calcium intake or total is not available.")
     }
    // print("CalciumPoints: \(CalciumPoints)")
    
    // Adequacy score - VITAMIN C 0-5 points
    var VitaminCPoints = 0.0
    if let vitaminCAI = user.adequateIntake[.vitaminC] {
         let vitaminCPercentage = (todayDailyFoodTotal.vitaminCTotal / vitaminCAI) * 100
         if vitaminCPercentage >= 100 {
             VitaminCPoints = 5.0
         } else {
             VitaminCPoints = (vitaminCPercentage / 100) * 5.0
         }
     } else {
         print("Vitamin C intake or total is not available.")
     }
     // print("VitaminCPoints: \(VitaminCPoints)")
    
    
    let adequacyScore = VegetableGroupPoints +
                        FruitGroupPoints +
                        GrainGroupPoints +
                        FiberPoints +
                        ProteinPoints +
                        IronPoints +
                        CalciumPoints +
                        VitaminCPoints
    
    // print("adequacyScore: \(adequacyScore)")

    //
    //
    // MODERATION 0-30 points
    //
    //
    
    // Moderation score - TOTAL FAT 0-6 points
    var TotalFatPoints = 0.0
    let totalFatPercentage = (todayDailyFoodTotal.fatTotal * 9 * 100) / caloriesTotal
    if totalFatPercentage <= 20 {
        TotalFatPoints = 6.0
    } else if (totalFatPercentage > 20) && (totalFatPercentage <= 30) {
        TotalFatPoints = 3.0
    }
    // print("TotalFatPoints: \(TotalFatPoints)")
    
    // Moderation score - SATURED FATS 0-6 points
    var SaturedFatPoints = 0.0
    let saturedFatPercentage = (todayDailyFoodTotal.saturedFatTotal * 9 * 100) / caloriesTotal
    if saturedFatPercentage <= 7 {
        SaturedFatPoints = 6.0
    } else if (saturedFatPercentage > 7) && (saturedFatPercentage <= 10) {
        SaturedFatPoints = 3.0
    }
    // print("SaturedFatPoints: \(SaturedFatPoints)")
    
    // Moderation score - CHOLESTEROL 0-6 points
    var CholesterolPoints = 0.0
    if todayDailyFoodTotal.cholesterolTotal <= 300 {
        CholesterolPoints = 6.0
    } else if (todayDailyFoodTotal.cholesterolTotal > 300) && (todayDailyFoodTotal.cholesterolTotal <= 400) {
        CholesterolPoints = 3.0
    }
    // print("CholesterolPoints: \(CholesterolPoints)")
    
    // Moderation score - SODIUM 0-6 points
    var SodiumPoints = 0.0
    if todayDailyFoodTotal.sodiumTotal <= 2400 {
        SodiumPoints = 6.0
    } else if (todayDailyFoodTotal.sodiumTotal > 2400) && (todayDailyFoodTotal.sodiumTotal <= 3400) {
        SodiumPoints = 3.0
    }
    // print("SodiumPoints: \(SodiumPoints)")
    
    // moderation score - EMPTY CALORIE FOODS 0-6 points -->> idea: aggiungere un code da assegnare
    var emptyCaloriesPoints = 0.0
    if todayDailyFoodTotal.emptyCalories <= 0.03 * caloriesTotal {
        emptyCaloriesPoints = 6.0
    } else if (todayDailyFoodTotal.emptyCalories > 0.03 * caloriesTotal) && (todayDailyFoodTotal.emptyCalories <= 0.1 * caloriesTotal) {
        emptyCaloriesPoints = 3.0
    }
    // print("emptyCaloriesPoints: \(emptyCaloriesPoints)")
    
    let moderationScore = TotalFatPoints +
                          SaturedFatPoints +
                          CholesterolPoints +
                          SodiumPoints +
                          emptyCaloriesPoints
    
    // print("moderationScore: \(moderationScore)")
    
    //
    //
    // OVERALL BALANCE 0-10 points
    //
    //
    
    // Macronutrient ratio (carbohydrate:protein:fat) - 0-6 points
    var balanceScore1 = 0
    let carbPercentage = (todayDailyFoodTotal.carbTotal * 4 * 100) / caloriesTotal
    if (carbPercentage >= 55 && carbPercentage <= 65) &&
       (proteinPercentage >= 10 && proteinPercentage <= 15) &&
       (totalFatPercentage >= 15 && totalFatPercentage <= 25) {
        balanceScore1 = 6
    } else if (carbPercentage >= 52 && carbPercentage <= 68) &&
              (proteinPercentage >= 9 && proteinPercentage <= 16) &&
              (totalFatPercentage >= 13 && totalFatPercentage <= 27){
        balanceScore1 = 4
    } else if (carbPercentage >= 50 && carbPercentage <= 70) &&
              (proteinPercentage >= 8 && proteinPercentage <= 17) &&
              (totalFatPercentage >= 12 && totalFatPercentage <= 30) {
        balanceScore1 = 2
    }
    // print("balanceScore1: \(balanceScore1)")
    
    // Fatty acid ratio (PUFA:MUFA:SFA) - 0-6 points
    // PUFA -> Polinsatured Fatty Acid
    // MUFA -> Monounsatured Fatty Acid
    // SFA  -> saturated fatty acids
    let P_S_ratio = todayDailyFoodTotal.PUFATotal / todayDailyFoodTotal.saturedFatTotal
    let M_S_ratio = todayDailyFoodTotal.MUFATotal / todayDailyFoodTotal.saturedFatTotal
    
    var balanceScore2 = 0
    if (P_S_ratio >= 1 && P_S_ratio <= 1.5) &&
        (M_S_ratio >= 1 && M_S_ratio <= 1.5) {
        balanceScore2 = 4
    } else if (P_S_ratio >= 0.8 && P_S_ratio <= 1.7) &&
                (M_S_ratio >= 0.8 && M_S_ratio <= 1.7) {
        balanceScore2 = 2
    }
    // print("balanceScore2: \(balanceScore2)")
    
    let overallBalanceScore = balanceScore1 + balanceScore2
    // print("overallBalanceScore: \(overallBalanceScore)")
    
    let DietQualityIndex = Double(varietyScore) +
                        adequacyScore +
                        moderationScore +
                        Double(overallBalanceScore)
    
    // print("DietQualityIndex: \(DietQualityIndex)")
    return DietQualityIndex
}
            

//
// func NutritionIndexFunction(context: ModelContext, MacronutrientsIndex: Double, DietQualityIndex: Double, todayDailyFoodTotal: DailyFoodTotal) {
//     let NutritionIndexOverall = (MacronutrientsIndex + DietQualityIndex) / 2
//
//
//
//     //let currentNutritionIndex = NutritionIndexes(MacronutrientsIndex: MacronutrientsIndex, DietQualityIndex: DietQualityIndex, // NutritionIndexOverall: NutritionIndexOverall, )
//     context.insert(currentNutritionIndex)
// }
//


// aggiungere anche gli altri indici

func BaccoIndexCalculator(context: ModelContext, MacronutrientsIndex: Double, DietQualityIndex: Double, todayDailyFoodTotal: DailyFoodTotal, sdnnScore: Double, rmssdScore: Double, PAScore: Double) {
    
    let calendar = Calendar.current
    let today = Date()
    let yesterday = calendar.date(byAdding: .day, value: -1, to: today)
    
    let NutritionIndexOverall = (MacronutrientsIndex + DietQualityIndex) / 2
    let MentalHealthIndexOverall = (sdnnScore + rmssdScore) / 2
    
    let carbTotal = todayDailyFoodTotal.carbTotal
    let proteinTotal = todayDailyFoodTotal.proteinTotal
    let fatTotal = todayDailyFoodTotal.fatTotal
    
    if (NutritionIndexOverall == 0 || MentalHealthIndexOverall == 0) {
        
        let BACCO = 0.0
        
        print("BaccoIndex: \(BACCO)")
        print("MentalIndex: \(MentalHealthIndexOverall)")
        print("NutritionIndex: \(NutritionIndexOverall)")
        print("PhysicalIndex: \(PAScore)")
        
        let currentBaccoIndex = BaccoIndexes(
            nutritionIndexes: ( .init(
                carbTotal: carbTotal,
                proteinTotal: proteinTotal,
                fatTotal: fatTotal,
                MacronutrientsIndex: MacronutrientsIndex,
                DietQualityIndex: DietQualityIndex,
                NutritionIndexOverall: NutritionIndexOverall)
            ),
            mentalHealthIndexes: ( .init(
                sdnnIndex: sdnnScore,
                rmssdIndex: rmssdScore,
                MentalHealthIndexOverall: MentalHealthIndexOverall)
            ),
            physicalActivityIndexes: PAScore,
            baccoIndex: BACCO,
            date: yesterday!
        )
        context.insert(currentBaccoIndex)

    } else {
        
        let BACCO = (NutritionIndexOverall + MentalHealthIndexOverall + PAScore) / 3
        
        print("BaccoIndex: \(BACCO)")
        print("MentalIndex: \(MentalHealthIndexOverall)")
        print("NutritionIndex: \(NutritionIndexOverall)")
        print("PhysicalIndex: \(PAScore)")
        
        let currentBaccoIndex = BaccoIndexes(
            nutritionIndexes: ( .init(
                carbTotal: carbTotal,
                proteinTotal: proteinTotal,
                fatTotal: fatTotal,
                MacronutrientsIndex: MacronutrientsIndex,
                DietQualityIndex: DietQualityIndex,
                NutritionIndexOverall: NutritionIndexOverall)
            ),
            mentalHealthIndexes: ( .init(
                sdnnIndex: sdnnScore,
                rmssdIndex: rmssdScore,
                MentalHealthIndexOverall: MentalHealthIndexOverall)
            ),
            physicalActivityIndexes: PAScore,
            baccoIndex: BACCO,
            date: yesterday!
        )
        context.insert(currentBaccoIndex)
    }

}
