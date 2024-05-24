//
//  FirstView.swift
//  BACCO
//
//  Created by GIF on 10/05/24.
//

import SwiftUI
import SwiftData
import Foundation

struct FirstView: View {
    @Environment(\.modelContext) var context
    @Query var baccoIndexes: [BaccoIndexes]
    @Query var HRV_Metrics: [HRVMetrics]
    
    var viewModel_MH = HeartbeatViewModel(heartbeats: [], intervals: [], recentHeartRates: [])
    var viewModel_PA = HealthKitManager(heartRateData: [])
    
    // battiti cardiaci raggruppati per minuto
    @State private var groupedHeartRates: [String: [HeartRateData]] = [:]
    // media dei battiti per minuto
    @State private var averages: [String: Double] = [:]
    // counter dei minuti trascorsi
    @State private var counters = MVPACounter(MPACounter: 0, VPACounter: 0)
    @State private var showAlert = false
    
    
    private func performAllCalculations(context: ModelContext) {
        let dbUser = try! context.fetch(FetchDescriptor<User>())
        //let dbBaccoIndexes = try! context.fetch(FetchDescriptor<BaccoIndexes>())
        let dbAddedFood = try! context.fetch(FetchDescriptor<AddedFood>())
        
        guard let user = dbUser.last else {
            print("No user found.")
            return
        }
        let MHR = user.MHR
        
        // Creare DispatchGroup per sincronizzare i calcoli
        let nutritionGroup = DispatchGroup()
        let mentalHealthGroup = DispatchGroup()
        let physicalActivityGroup = DispatchGroup()
        
        // Creare DispatchGroup principale per sincronizzare tutti i gruppi
        let allGroups = DispatchGroup()
        
        // Variabili per i risultati dei calcoli
        var todayDailyFoodTotal: DailyFoodTotal?
        var MacronutrientsIndex: Double?
        var DietQualityIndex: Double?
        var PA_Index: Double?
        
        var sdnnRealScore = 0.0
        var rmssdRealScore = 0.0
        
        
        // Calcoli Nutrition
        allGroups.enter()
        nutritionGroup.enter()
        DispatchQueue.global().async {
            todayDailyFoodTotal = TotalCounterFunction(context: context)
            MacronutrientsIndex = MacronutrientsIndexFunction(context: context, todayDailyFoodTotal: todayDailyFoodTotal!)
            DietQualityIndex = DQICalculatorFunction(context: context, todayDailyFoodTotal: todayDailyFoodTotal!)
            nutritionGroup.leave()
        }
        nutritionGroup.notify(queue: .main) {
            allGroups.leave()
        }
        
        // Calcoli Mental Health
        allGroups.enter()
        mentalHealthGroup.enter()
        viewModel_MH.loadHeartbeatData() {
            if self.viewModel_MH.intervals.isEmpty {
                print("Mental Health data intervals are empty.")
                mentalHealthGroup.leave()
            } else {
                print("Loaded Mental Health data intervals.")
                self.viewModel_MH.loadRestingHeartRate() {
                    let (sdnnValue, rmssdValue) = calculateMetrics(values: self.viewModel_MH.intervals, context: context, hr: self.viewModel_MH.recentHeartRates)
                    let (sdnnScore, rmssdScore) = performHRVcalculation(context: context, sdnnValue: sdnnValue, rmssdValue: rmssdValue)
                    sdnnRealScore = sdnnScore
                    rmssdRealScore = rmssdScore
                    print("Calculated Mental Health scores: SDNN = \(sdnnRealScore), RMSSD = \(rmssdRealScore)")
                    mentalHealthGroup.leave()
                }
            }
        }
        mentalHealthGroup.notify(queue: .main) {
            allGroups.leave()
        }
        
        // Calcoli Physical Activity
        allGroups.enter()
        physicalActivityGroup.enter()
        DispatchQueue.global().async {
            DeletePunteggioDB(context: context)
            self.viewModel_PA.readHeartRateDataFromYesterday {
                if self.viewModel_PA.heartRateData.isEmpty {
                    print("Heart rate data from yesterday is empty.")
                    SalvaPunteggio_SenzaAllenamento(context: context)
                    //  physicalActivityGroup.leave()
                } else {
                    print("Loaded heart rate data from yesterday.")
                    let groupedHeartRates = groupHeartRatesByMinute(data: self.viewModel_PA.heartRateData)
                    let averages = calculateAverageHeartRates(groupedHeartRates: groupedHeartRates)
                    SalvaPunteggio(context: context, MHR: MHR, averages: averages)
                    // physicalActivityGroup.leave()
                }
                
                let weeklygoal = WeeklyGoal(lpa: user.lpa)
                PA_Index = DailyIndexPACalculation(context: context, weeklygoal: weeklygoal)
                physicalActivityGroup.leave()

            }
        }
        physicalActivityGroup.notify(queue: .main) {
            allGroups.leave()
        }
        
        
        // Aspetta che tutti i gruppi siano completati prima di salvare il BaccoIndex
        allGroups.notify(queue: .main) {
            print("All groups completed.")
            print("check: \(String(describing: PA_Index))")
            guard let MacronutrientsIndex = MacronutrientsIndex,
                  let DietQualityIndex = DietQualityIndex,
                  let todayDailyFoodTotal = todayDailyFoodTotal,
                  let PA_Index = PA_Index
            else {
                print("Failed to compute some indexes.")
                return
            }
            
            BaccoIndexCalculator(context: context, MacronutrientsIndex: MacronutrientsIndex, DietQualityIndex: DietQualityIndex, todayDailyFoodTotal: todayDailyFoodTotal, sdnnScore: sdnnRealScore, rmssdScore: rmssdRealScore, PAScore: PA_Index)
            
            // Svuotare database AddedFood
            for AddedFood in dbAddedFood {
                context.delete(AddedFood)
            }
        }
    }
    
    
    private func checkBaccoIndex(context: ModelContext) {
        print("checkBaccoIndex called.")
        let calendar = Calendar.current
        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)
        
        do {
            let dbBaccoIndexes = try context.fetch(FetchDescriptor<BaccoIndexes>())
            for baccoIndex in dbBaccoIndexes {
                if calendar.isDate(baccoIndex.date, inSameDayAs: yesterday!) {
                    print("BaccoIndex already exists for today.")
                    return
                }
            }
            
            // Se nessun BaccoIndex per oggi è stato trovato, esegui i calcoli
            print("No BaccoIndex for today found. Performing calculations.")
            performAllCalculations(context: context)
        } catch {
            print("Failed to fetch BaccoIndexes: \(error)")
        }
    }


    
    var body: some View {
        let progressValue = baccoIndexes.last?.baccoIndex ?? 0.0
        
        NavigationStack {
            VStack(spacing: 20) {
                Text("Your Bacco Index!")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, 60)
                Spacer()
                    .frame(width: 50, height: 50, alignment: .center)
                
                if progressValue != 0.0 {
                    Image(wellnessImage(for: Int(progressValue)))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                    
                    ProgressView(value: progressValue, total: 100.0)
                        .progressViewStyle(LinearProgressViewStyle(tint: colorForValue(Int(progressValue))))
                        .scaleEffect(x: 1, y: 5, anchor: .center)
                        .frame(width: 250)
                        .padding(.horizontal, 30)
                    
                    Text("\(progressValue, specifier: "%.0f")")
                        .font(.headline)
                } else {
                    Image("Image")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                    
                    HStack {
                        Text("Bacco Index not available")
                        
                        Button(action: {
                            showAlert = true
                        }) {
                            Image(systemName: "info.circle")
                                .foregroundColor(Color.green)
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Bacco Index not available"),
                                message: Text("Yesterday you forgot to log your meals or do your mindfulness session, so we do not have enough data to show you your daily Bacco Index :( \n Remember to do everything today and come back tomorrow!"),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    }
                }
                
                
                NavigationLink(destination: PastDaysView_BI()) {
                    Text("Show Previous Days")
                        .foregroundColor(.black)
                }
                Spacer()
            }
            .onAppear {
                print("FirstView appeared.")
                checkBaccoIndex(context: context)
            }
            
            
            VStack(spacing: 10) {
                NavigationLink(destination: ThreeIndexesView()) {
                    Text("Show me the details!")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#62a230"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 30)
        }
    }
    
    func wellnessImage(for score: Int) -> String {
        switch score {
        case 0...39:
            return "40-0"
        case 40...59:
            return "60-40"
        case 60...79:
            return "80-60"
        case 80...100:
            return "100-80"
        default:
            return "40-0"
        }
    }
}

#Preview {
    FirstView()
}



//
// Funzione per cambiare colore barra
//

func colorForValue(_ value: Int) -> Color {
    switch value {
    case 0...39:
        return Color(hex: "#db3130")
    case 40...59:
        return Color(hex: "#ffbd59")
    case 60...79:
        return Color(hex: "#9bcf53")
    case 80...100:
        return Color(hex: "#62a230")
    default:
        return .gray
    }
}




//
//
// VISUALIZZAZIONE TRE INDICI
//
//

struct ThreeIndexesView: View {
    
    @Query var baccoIndexes: [BaccoIndexes]
    @Query var saved_users: [User]
    
    @Environment (\.modelContext) var context
    @Environment (\.dismiss) private var dismiss
    
    var body: some View {
        let nutritionProgress = baccoIndexes.last?.nutritionIndexes.NutritionIndexOverall ?? 0.0
        let physicalActivityProgress = baccoIndexes.last?.physicalActivityIndexes ?? 0.0
        let mentalHealthProgress = baccoIndexes.last?.mentalHealthIndexes.MentalHealthIndexOverall ?? 0.0
        
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()
                IndexView(title: "Nutrition", progress: nutritionProgress, imageName: "fork.knife", destination: NewNutritionView())
                IndexView(title: "Physical Activity", progress: physicalActivityProgress, imageName: "figure.walk", destination: PhysicalActivityView())
                IndexView(title: "Mental Health", progress: mentalHealthProgress, imageName: "brain.head.profile", destination: MentalHealthView())
                Spacer()
            }
            .padding()
            .background(Color.gray.opacity(0.05).ignoresSafeArea())
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    if !saved_users.isEmpty {
                        NavigationLink(destination: SavedDataView(user: saved_users.last!), label: {
                            VStack {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color(hex: "#62a230"))
                                Text("My Profile")
                                    .font(.caption2)
                                    .foregroundColor(Color(hex: "#62a230"))
                            }
                        })
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: FoodTrackerView(), label: {
                        VStack {
                            Image(systemName: "plus")
                                .font(.system(size: 24))
                                .foregroundColor(Color(hex: "#62a230"))
                            Text("Add Meal")
                                .font(.caption2)
                                .foregroundColor(Color(hex: "#62a230"))
                        }
                    })
                    
                    Spacer()
                }
            }
        }
    }
}
    
    
    
struct IndexView<Destination: View>: View {
    let title: String
    let progress: Double
    let imageName: String
    let destination: Destination
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray.opacity(0.12), radius: 5)
                .padding(.horizontal)
            VStack {
                NavigationLink(destination: destination) {
                    Text(title)
                        .font(.largeTitle)
                        .foregroundColor(Color.black)
                }
                .padding()
                
                HStack {
                    Image(systemName: imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color.black)
                    
                    ProgressView(value: progress, total: 100.0)
                        .progressViewStyle(LinearProgressViewStyle(tint: colorForValue(Int(progress))))
                        .scaleEffect(x: 1, y: 5, anchor: .center)
                        .frame(width: 220)
                        .padding(.horizontal, 10)
                }
                .padding(.horizontal, 30)
            }
            .padding()
        }
        .frame(height: 150)
        .padding(.bottom, 10)
    }
}


#Preview {
  ThreeIndexesView()
}
