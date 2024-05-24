//
//  MindfulnessCounter.swift
//  BACCO
//
//  Created by GIF on 15/05/24.
//

import Foundation
import SwiftData
import SwiftUI
import HealthKit


struct MindfulnessView: View {
    @State private var showInfoAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("You are almost there!")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#62a230"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 35)
                    .padding(.top, 20)

                Spacer()
                
                Text("To give you the best **Mental Health Index** we need to have a starting point to define your **standard metrics**.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 35)
                    .padding(.bottom, 30)
                
                Image("immagine_mindfulness")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 130, height: 130)
                    .padding(.bottom, 30)
                
                Text("For the best result, do **10 breathing sessions** today using the Mindfulness App on your Apple Watch.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 35)
                    .padding(.bottom, 10)
                Text("For more information, tap the info button below.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.gray)
                    .padding(.horizontal, 35)
                    .padding(.bottom, 20)
                
                Button(action: {
                    showInfoAlert = true
                }) {
                    Image(systemName: "info.circle")
                        .foregroundColor(Color(hex: "#64a20d"))
                }
                .alert(isPresented: $showInfoAlert) {
                    Alert(title: Text("Breathing session tips"), message: Text("To complete a mindfulness session, open the Mindfulness App available on your Apple Watch and navigate to the Breathe section.\nTo improve score accuracy, choose the duration that best fits your routine and maintain it throughout the use of the application.\nFor the Mental Health section, it is advisable to perform the daily mindfulness session without altering your normal breathing rate. \nIdeally, conduct the session in the morning while you are at rest."), dismissButton: .default(Text("Got it!")))
                }
                .padding(.bottom, 20)
                
                Spacer()
                
                NavigationLink(destination: MindfulnessCounterView().navigationBarBackButtonHidden(true)) {
                    Text("Next")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#62a230"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)
            }
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .navigationBarBackButtonHidden(true)
    }
}

struct MindfulnessView_Previews: PreviewProvider {
     static var previews: some View {
         MindfulnessView()
     }
}




struct MindfulnessCounterView: View {
    @Environment(\.modelContext) var context
    @Query var saved_users: [User]
    @State private var isExpandedNutrition = false
    @State private var isExpandedMentalHealth = false
    @State private var isExpandedPhysicalActivity = false
    @State private var intervalsData: [[Double]] = []
    @State private var showAlert = false
    @State private var showInfoAlert = false
    @State private var missingSessionsCount = 0
    private var healthDataManager = HealthDataManager()
    private var healthKitManager = HealthKitManager(heartRateData: [])
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Setting up your Mental Health standard values")
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#62a230"))
                        .multilineTextAlignment(.center)
                        //.padding(.top, 40)
                        
                    
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(Color.white)
                        .frame(width: 370, height: 250, alignment: .center)
                        .shadow(color: .gray.opacity(0.12), radius: 5)
                        .overlay {
                            //VStack {
                                if intervalsData.isEmpty {
                                    VStack(spacing: 10) {
                                        HStack {
                                            Image(systemName: "hourglass")
                                                .foregroundColor(Color(hex: "#62a230"))
                                                .font(.system(size: 24))
                                            Text("You need \(missingSessionsCount) more Mindfulness sessions")
                                                .font(.body)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.gray)
                                        }
                                        .padding()
                                        Button(action: {
                                            showInfoAlert = true
                                        }) {
                                            Image(systemName: "info.circle")
                                                .foregroundColor(Color(hex: "#64a20d"))
                                        }
                                        .alert(isPresented: $showInfoAlert) {
                                            Alert(title: Text("Breathing session tips"), message: Text("To complete a mindfulness session, open the Mindfulness App available on your Apple Watch and navigate to the Breathe section.\nTo improve score accuracy, choose the duration that best fits your routine and maintain it throughout the use of the application.\nFor the Mental Health section, it is advisable to perform the daily mindfulness session without altering your normal breathing rate. \nIdeally, conduct the session in the morning while you are at rest."), dismissButton: .default(Text("Got it!")))
                                        }
                                        
                                    }
                                    
                                } else {
                                    ProvaView()
                                        .onAppear {
                                            fetchHRDataAndProcessIntervals(context: context)
                                            Inizializzazione_Punteggio(context: context)
                                        }
                                }
                            //}
                        }
                    
                    // Custom DisclosureGroup for Nutrition
                    VStack {
                        HStack {
                            Text("Nutrition")
                                .font(.headline)
                                .foregroundColor(Color(hex: "#62a230"))
                            Spacer()
                            Image(systemName: isExpandedNutrition ? "chevron.up" : "chevron.down")
                                .foregroundColor(Color(hex: "#62a230"))
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(color: .gray.opacity(0.12), radius: 5))
                        .frame(width: 370)
                        .onTapGesture {
                            withAnimation {
                                isExpandedNutrition.toggle()
                            }
                        }
                        
                        if isExpandedNutrition {
                            VStack {
                                Text("Diet significantly impacts both short-term vitality and long-term health, with unhealthy eating habits increasing the risk of cardiovascular diseases, obesity, hypertension, stroke, and diabetes. \nProper nutrition is crucial for providing the **energy** and **nutrients** needed for effective and sustainable physical activity, while poor dietary choices can hinder exercise performance. \nThe **nutrition index** is based on two main aspects:\n*1.* Balance of macro-nutrients and Energy Needs: adherence to these recommendations is expressed as a percentage, with optimal consumption earning full points and deviations reducing the score.\n*2.* Diet Quality:\n* Assessed using the Diet Quality Index-International (DQI-I), which evaluates variety, adequacy, moderation, and balance in the diet.\n* The score is expressed as a percentage and reflects the overall quality of the diet. \nThe overall nutrition index averages the scores from these two aspects, each evaluated on a scale from 0 to 100.")
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                            .frame(width: 370)
                        }
                    }
                    
                    // Custom DisclosureGroup for Physical Activity
                    VStack {
                        HStack {
                            Text("Physical Activity")
                                .font(.headline)
                                .foregroundColor(Color(hex: "#62a230"))
                            Spacer()
                            Image(systemName: isExpandedPhysicalActivity ? "chevron.up" : "chevron.down")
                                .foregroundColor(Color(hex: "#62a230"))
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(color: .gray.opacity(0.12), radius: 5))
                        .frame(width: 370)
                        .onTapGesture {
                            withAnimation {
                                isExpandedPhysicalActivity.toggle()
                            }
                        }

                        if isExpandedPhysicalActivity {
                            VStack {
                                Text("Regular **physical activity** (PA) is essential for overall health, positively impacting both **physical and mental well-being**. It helps prevent chronic diseases such as cardiovascular disease, diabetes, and obesity, while improving cardio-respiratory, vascular, musculoskeletal, and metabolic health. Additionally, PA enhances psychological wellness and cognitive function by reducing stress and anxiety.\n The chosen approach to define the index involves comparing individuals’ activity rates with guidelines set by the **World Health Organization (WHO)**. WHO recommends 150–300 minutes of moderate-intensity or 75–150 minutes of vigorous-intensity PA per week for healthy adults. An equivalent combination of both is possible, considering one minute of vigorous activity equals two minutes of moderate activity. The user's **weekly minutes goal** is determined by their initial PA level, and exercise intensity is defined using the **Maximum Heart Rate (MHR)**.")
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                            .frame(width: 370)
                        }
                    }
                    
                    
                    // Custom DisclosureGroup for Mental Health
                    VStack {
                        HStack {
                            Text("Mental Health")
                                .font(.headline)
                                .foregroundColor(Color(hex: "#62a230"))
                            Spacer()
                            Image(systemName: isExpandedMentalHealth ? "chevron.up" : "chevron.down")
                                .foregroundColor(Color(hex: "#62a230"))
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(color: .gray.opacity(0.12), radius: 5))
                        .frame(width: 370)
                        .onTapGesture {
                            withAnimation {
                                isExpandedMentalHealth.toggle()
                            }
                        }

                        if isExpandedMentalHealth {
                            VStack {
                                Text("Mental health is profoundly impacted by **stress**, which involves biological and psychological reactions linked to the **autonomic nervous system**.\n**Heart Rate Variability** (HRV) can assess stress levels and resilience, indicating one's ability to **restore equilibrium** post-stress and reduce anxiety.\nThe Bacco’s Mental Health Index assesses stress levels using **Heart Rate Variability** (HRV) metrics: **Root Mean Square of Successive Differences** (RMSSD) and **Standard Deviation of Normal to Normal heartbeats** (SDNN).\nThese metrics capture parasympathetic nervous system activity and overall health, distinguishing between stressful and non-stressful conditions.\nHRV data is collected during a **mindfulness session**, which should preferably be conducted in the **morning** while seated and at **rest**. RMSSD and SDNN values are calculated daily.\nScores for RMSSD and SDNN are assigned based on comparisons with predefined ranges:\n* **Physiological Range** (PR): Represents norms for healthy individuals during low stress.\n* **User’s Range** (UR): Based on the user’s historical data.\nScoring and Index Calculation:\nEach metric is scored from 0 to 100, reflecting stress levels.\nThe Mental Health Index averages the RMSSD and SDNN scores. Higher scores indicate a more **relaxed state**.\nThis comprehensive approach provides users with a clear representation of their daily stress levels and overall mental health, allowing for better stress management and well-being.")
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                            .frame(width: 370)
                        }
                    }
                    
                }
                .padding(.horizontal)
                .padding(.top, 20)
            }
            .background(Color.gray.opacity(0.05).ignoresSafeArea(.all))
            
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
            .onAppear {
                updateUIBasedOnSessionCount()
            }
        }
    }
    
    func fetchHRDataAndProcessIntervals(context: ModelContext) {
        let metricsCount = (try? context.fetch(FetchDescriptor<HRVMetrics>()).count) ?? 0

        if metricsCount >= 10 {
            print("Already have 10 or more HRVMetrics entries.")
            return
        }
        
        healthKitManager.fetchLastSevenRestingHeartRates { (hrData, error) in
            guard let hrData = hrData else {
                print("Error fetching HR data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                for sessionIntervals in self.intervalsData {
                    calculateMetrics2(values: sessionIntervals, context: self.context, hr: hrData)
                }
            }
        }
    }
    
    func updateUIBasedOnSessionCount() {
        healthDataManager.retrieveRecentMindfulnessSessions { (sessions, missingSessions) in
            DispatchQueue.main.async {
                if let missing = missingSessions {
                    self.missingSessionsCount = missing
                    self.showAlert = true
                } else if let sessions = sessions {
                    healthDataManager.retrieveBeatToBeatDataForMindfulnessSessions(sessions: sessions) { data in
                        DispatchQueue.main.async {
                            self.calculateIntervalsPerSession(data: data)
                        }
                    }
                }
            }
        }
    }
    
    func calculateIntervalsPerSession(data: [[TimeInterval]]) {
        intervalsData = data.map { sessionData in
            guard sessionData.count > 1 else { return [] }
            var intervals = [Double]()
            for i in 0..<sessionData.count - 1 {
                let interval = sessionData[i + 1] - sessionData[i]
                if interval < 1.3 {
                    intervals.append(interval * 1000)
                }
            }
            return intervals
        }
    }
}

@Observable class HealthDataManager {
    let healthStore = HKHealthStore()

    func retrieveRecentMindfulnessSessions(completion: @escaping ([HKCategorySample]?, Int?) -> Void) {
        let mindfulnessType = HKObjectType.categoryType(forIdentifier: .mindfulSession)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        // Modificato il limite a 10
        let query = HKSampleQuery(sampleType: mindfulnessType, predicate: nil, limit: 10, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            guard let samples = samples as? [HKCategorySample], error == nil else {
                print("Error retrieving mindfulness sessions: \(error!.localizedDescription)")
                completion(nil, nil)
                return
            }
            
            // Se il numero di campioni recuperati è inferiore a 10, passa il numero di sessioni mancanti
            if samples.count < 10 {
                completion(nil, 10 - samples.count)
            } else {
                // Se il numero di campioni è almeno 10, passa i campioni recuperati
                completion(samples, nil)
            }
        }
        
        healthStore.execute(query)
    }


    func retrieveBeatToBeatDataForMindfulnessSessions(sessions: [HKCategorySample], completion: @escaping ([[TimeInterval]]) -> Void) {
        var allSessionsHeartbeats = [[TimeInterval]]()
        let group = DispatchGroup()
        
        for session in sessions {
            group.enter()
            var sessionHeartbeats = [TimeInterval]()
            let samplePredicate = HKQuery.predicateForSamples(withStart: session.startDate, end: session.endDate, options: .strictStartDate)
            let heartbeatSeriesType = HKSeriesType.heartbeat()
            let query = HKSampleQuery(sampleType: heartbeatSeriesType, predicate: samplePredicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, samples, error in
                guard let samples = samples as? [HKHeartbeatSeriesSample], error == nil else {
                    print("Error retrieving heartbeats: \(error!.localizedDescription)")
                    group.leave()
                    return
                }

                for sample in samples {
                    let heartbeatSeriesQuery = HKHeartbeatSeriesQuery(heartbeatSeries: sample) { query, timeSinceStart, precededByGap, done, error in
                        guard error == nil else {
                            print("Error querying heartbeats: \(error!.localizedDescription)")
                            return
                        }
                        sessionHeartbeats.append(timeSinceStart)
                        if done {
                            allSessionsHeartbeats.append(sessionHeartbeats)
                            group.leave()
                        }
                    }
                    self.healthStore.execute(heartbeatSeriesQuery)
                }
                if samples.isEmpty {
                    allSessionsHeartbeats.append([])
                    group.leave()
                }
            }
            self.healthStore.execute(query)
        }

        group.notify(queue: .main) {
            completion(allSessionsHeartbeats)
        }
    }
}





struct ProvaView: View {
    @State private var isExpandedNutrition = false
    @State private var isExpandedMentalHealth = false
    @State private var isExpandedPhysicalActivity = false
    @Query var saved_users: [User]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Well done!")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#62a230"))
                        .multilineTextAlignment(.center)
                        .padding(.top, 40)
                    
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(Color.white)
                        .frame(width: 370, height: 250, alignment: .center)
                        .shadow(color: .gray.opacity(0.12), radius: 5)
                        .overlay {
                            VStack(spacing: 20) {
                                HStack(alignment: .center, spacing: 10) {
                                    Image(systemName: "hand.thumbsup.fill")
                                        .foregroundColor(Color(hex: "#62a230"))
                                        .font(.system(size: 30))
                                        .padding(.leading, -6) // Sposta il pollice leggermente a sinistra
                                    Text("Now we have everything to calculate your Bacco Index tomorrow!")
                                        .font(.body)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                }
                                
                                HStack(alignment: .center, spacing: 10) {
                                    Image(systemName: "fork.knife")
                                        .foregroundColor(Color(hex: "#62a230"))
                                        .font(.system(size: 30))
                                        .padding(.leading, -31)
                                    Text("Remember to log your daily meal!")
                                        .font(.body)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                }
                                
                            }
                            .padding(.horizontal, 20)
                        }
                    
                    
                    
                    // Nutrition Disclosure Group
                    VStack {
                        HStack {
                            Text("Nutrition")
                                .font(.headline)
                                .foregroundColor(Color(hex: "#62a230"))
                            Spacer()
                            Image(systemName: isExpandedNutrition ? "chevron.up" : "chevron.down")
                                .foregroundColor(Color(hex: "#62a230"))
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(color: .gray.opacity(0.12), radius: 5))
                        .frame(width: 370)
                        .onTapGesture {
                            withAnimation {
                                isExpandedNutrition.toggle()
                            }
                        }

                        if isExpandedNutrition {
                            VStack {
                                Text("Diet significantly impacts both short-term vitality and long-term health, with unhealthy eating habits increasing the risk of cardiovascular diseases, obesity, hypertension, stroke, and diabetes. /nProper nutrition is crucial for providing the **energy** and **nutrients** needed for effective and sustainable physical activity, while poor dietary choices can hinder exercise performance. \nThe **nutrition index** is based on two main aspects:\n*1.* Balance of macro-nutrients and Energy Needs: adherence to these recommendations is expressed as a percentage, with optimal consumption earning full points and deviations reducing the score.\n*2.* Diet Quality:\n* Assessed using the Diet Quality Index-International (DQI-I), which evaluates variety, adequacy, moderation, and balance in the diet.\n* The score is expressed as a percentage and reflects the overall quality of the diet. \nThe overall nutrition index averages the scores from these two aspects, each evaluated on a scale from 0 to 100.")
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                            .frame(width: 370)
                        }
                    }
                    
                    // Physical Activity Disclosure Group
                    VStack {
                        HStack {
                            Text("Physical Activity")
                                .font(.headline)
                                .foregroundColor(Color(hex: "#62a230"))
                            Spacer()
                            Image(systemName: isExpandedPhysicalActivity ? "chevron.up" : "chevron.down")
                                .foregroundColor(Color(hex: "#62a230"))
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(color: .gray.opacity(0.12), radius: 5))
                        .frame(width: 370)
                        .onTapGesture {
                            withAnimation {
                                isExpandedPhysicalActivity.toggle()
                            }
                        }

                        if isExpandedPhysicalActivity {
                            VStack {
                                Text("Regular **physical activity** (PA) is essential for overall health, positively impacting both **physical and mental well-being**. It helps prevent chronic diseases such as cardiovascular disease, diabetes, and obesity, while improving cardio-respiratory, vascular, musculoskeletal, and metabolic health. Additionally, PA enhances psychological wellness and cognitive function by reducing stress and anxiety.\n The chosen approach to define the index involves comparing individuals’ activity rates with guidelines set by the **World Health Organization (WHO)**. WHO recommends 150–300 minutes of moderate-intensity or 75–150 minutes of vigorous-intensity PA per week for healthy adults. An equivalent combination of both is possible, considering one minute of vigorous activity equals two minutes of moderate activity. The user's **weekly minutes goal** is determined by their initial PA level, and exercise intensity is defined using the **Maximum Heart Rate (MHR)**.")
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                            .frame(width: 370)
                        }
                    }
                    
                    // Mental Health Disclosure Group
                    VStack {
                        HStack {
                            Text("Mental Health")
                                .font(.headline)
                                .foregroundColor(Color(hex: "#62a230"))
                            Spacer()
                            Image(systemName: isExpandedMentalHealth ? "chevron.up" : "chevron.down")
                                .foregroundColor(Color(hex: "#62a230"))
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(color: .gray.opacity(0.12), radius: 5))
                        .frame(width: 370)
                        .onTapGesture {
                            withAnimation {
                                isExpandedMentalHealth.toggle()
                            }
                        }

                        if isExpandedMentalHealth {
                            VStack {
                                Text("Mental health is profoundly impacted by **stress**, which involves biological and psychological reactions linked to the **autonomic nervous system**.\n**Heart Rate Variability** (HRV) can assess stress levels and resilience, indicating one's ability to **restore equilibrium** post-stress and reduce anxiety.\nThe Bacco’s Mental Health Index assesses stress levels using **Heart Rate Variability** (HRV) metrics: **Root Mean Square of Successive Differences** (RMSSD) and **Standard Deviation of Normal to Normal heartbeats** (SDNN).\nThese metrics capture parasympathetic nervous system activity and overall health, distinguishing between stressful and non-stressful conditions.\nHRV data is collected during a **mindfulness session**, which should preferably be conducted in the **morning** while seated and at **rest**. RMSSD and SDNN values are calculated daily.\nScores for RMSSD and SDNN are assigned based on comparisons with predefined ranges:\n* **Physiological Range** (PR): Represents norms for healthy individuals during low stress.\n* **User’s Range** (UR): Based on the user’s historical data.\nScoring and Index Calculation:\nEach metric is scored from 0 to 100, reflecting stress levels.\nThe Mental Health Index averages the RMSSD and SDNN scores. Higher scores indicate a more **relaxed state**.\nThis comprehensive approach provides users with a clear representation of their daily stress levels and overall mental health, allowing for better stress management and well-being.")
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                            .frame(width: 370)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
            }
            .background(Color.gray.opacity(0.05).ignoresSafeArea(.all))
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Spacer()
                        NavigationLink(destination: SavedDataView(user: saved_users.last!), label: {
                            VStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(Color(hex: "#62a230"))
                                Spacer()
                                Text("My Profile")
                                    .font(.caption2)
                                    .foregroundColor(Color(hex: "#62a230"))
                            }
                        })
                        .padding(.leading, 20)
                        
                        Spacer()
                        
                        NavigationLink(destination: FoodTrackerView(), label: {
                            VStack {
                                Image(systemName: "plus")
                                    .foregroundColor(Color(hex: "#62a230"))
                                Spacer()
                                Text("Add Meal")
                                    .font(.caption2)
                                    .foregroundColor(Color(hex: "#62a230"))
                            }
                        })
                        .padding(.leading, 20)
                        Spacer()
                    }
                }
            }
        }
    }
}
