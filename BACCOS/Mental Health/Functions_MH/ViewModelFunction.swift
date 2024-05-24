//
//  ViewModelFunction.swift
//  BACCO
//
//  Created by GIF on 10/05/24.
//

import HealthKit

class HealthKitManager {
    let healthStore = HKHealthStore()
    var heartRateData: [HeartRateData] = []
    init(heartRateData: [HeartRateData]) {
        self.heartRateData = heartRateData
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
            guard HKHealthStore.isHealthDataAvailable() else {
                print("Health data is not available on this device.")
                completion(false)
                return
            }
            
            let typesToRead: Set = [
                HKObjectType.quantityType(forIdentifier: .heartRate)!,
                HKObjectType.quantityType(forIdentifier: .restingHeartRate)!,
                HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
                HKSeriesType.heartbeat(),
                HKObjectType.categoryType(forIdentifier: .mindfulSession)!,
                HKObjectType.workoutType()
            ]
        
            healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
                if let error = error {
                    print("Error requesting authorization: \(error.localizedDescription)")
                    return
                }
                print(success ? "Authorization granted." : "Authorization denied.")
                completion(success)
            }
        }
    
    func readHeartRateDataFromYesterday(completion: @escaping () -> Void) {
        let workoutType = HKObjectType.workoutType()
        let calendar = Calendar.current
        let today = Date()
        
        // Calcola la data di inizio di un giorno fa
        guard let oneDayAgoStart = calendar.date(byAdding: .day, value: -1, to: today) else {
            print("Cannot calculate the date for one day ago")
            completion()
            return
        }
        let startOfOneDayAgo = calendar.startOfDay(for: oneDayAgoStart)
        
        // Calcola la data di fine di un giorno fa
        guard let endOfOneDayAgo = calendar.date(byAdding: .day, value: 1, to: startOfOneDayAgo)?.addingTimeInterval(-1) else {
            print("Cannot calculate the end date for one day ago")
            completion()
            return
        }
        
        print("Querying workouts from \(startOfOneDayAgo) to \(endOfOneDayAgo)")
        
        // Creiamo un predicato per i workout di un giorno fa.
        let oneDayAgoPredicate = HKQuery.predicateForSamples(withStart: startOfOneDayAgo, end: endOfOneDayAgo, options: .strictStartDate)
        
        // Creiamo una query per ottenere i workout di un giorno fa.
        let workoutQuery = HKSampleQuery(sampleType: workoutType, predicate: oneDayAgoPredicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { [weak self] (query, samples, error) in
            if let error = error {
                print("Failed to fetch workouts from one day ago: \(error.localizedDescription)")
                self?.heartRateData = []
                completion()
                return
            }
            
            guard let workouts = samples as? [HKWorkout], !workouts.isEmpty else {
                print("No workouts found from one day ago.")
                self?.heartRateData = []
                completion()
                return
            }
            
            print("Found \(workouts.count) workouts from one day ago.")
            
            let dispatchGroup = DispatchGroup()
            
            for workout in workouts {
                dispatchGroup.enter()
                let predicate = HKQuery.predicateForSamples(withStart: workout.startDate, end: workout.endDate, options: .strictStartDate)
                guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
                    print("Cannot get heart rate type")
                    dispatchGroup.leave()
                    return
                }
                
                let heartRateQuery = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { [weak self] (query, samples, error) in
                    if let error = error {
                        print("Failed to fetch heart rate data from workout: \(error.localizedDescription)")
                        dispatchGroup.leave()
                        return
                    }
                    
                    guard let samples = samples as? [HKQuantitySample], !samples.isEmpty else {
                        print("No heart rate data found for workout starting at \(workout.startDate)")
                        dispatchGroup.leave()
                        return
                    }
                    
                    print("Found \(samples.count) heart rate samples for workout starting at \(workout.startDate)")
                    
                    let heartRates = samples.map { HeartRateData(value: $0.quantity.doubleValue(for: HKUnit(from: "count/min")), date: $0.startDate) }
                    DispatchQueue.main.async {
                        self?.heartRateData.append(contentsOf: heartRates)
                        print("Updated heart rate data: \(self?.heartRateData.count ?? 0) samples in total.")
                        dispatchGroup.leave()
                    }
                }
                
                self?.healthStore.execute(heartRateQuery)
            }
            
            dispatchGroup.notify(queue: .main) {
                completion()
            }
        }
        
        healthStore.execute(workoutQuery)
    }

    
    func retrieveFirstDailyMindfulnessSession(completion: @escaping (HKCategorySample?) -> Void) {
        let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession)!
        let calendar = Calendar.current
        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)
        let startOfYesterday = calendar.startOfDay(for: yesterday!)
        let endOfYesterday = calendar.date(byAdding: .day, value: 1, to: startOfYesterday)?.addingTimeInterval(-1)
        let predicate = HKQuery.predicateForSamples(withStart: startOfYesterday, end: endOfYesterday, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        
        let query = HKSampleQuery(sampleType: mindfulType, predicate: predicate, limit: 1, sortDescriptors: [sortDescriptor]) { query, result, error in
            guard let session = result?.first as? HKCategorySample, error == nil else {
                print("Error fetching the first mindfulness session of yesterday: \(String(describing: error?.localizedDescription))")
                completion(nil)
                return
            }
            completion(session)
        }
        healthStore.execute(query)
    }

    func fetchLastSevenRestingHeartRates(completion: @escaping ([Double]?, Error?) -> Void) {
        guard let restingHeartRateType = HKObjectType.quantityType(forIdentifier: .restingHeartRate) else {
            completion(nil, NSError(domain: "HealthKit", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to access resting heart rate type"]))
            return
        }

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: restingHeartRateType, predicate: nil, limit: 7, sortDescriptors: [sortDescriptor]) { query, samples, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, error)
                    return
                }

                if let samples = samples {
                    let values = samples.compactMap { sample -> Double? in
                        if let sample = sample as? HKQuantitySample {
                            return sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
                        }
                        return nil
                    }
                    completion(values, nil)
                } else {
                    completion(nil, NSError(domain: "HealthKit", code: 1, userInfo: [NSLocalizedDescriptionKey: "No resting heart rate data found"]))
                }
            }
        }

        healthStore.execute(query)
    }


    func retrieveBeatToBeatDataForMindfulnessSession(session: HKCategorySample?, completion: @escaping ([TimeInterval]) -> Void) {
        guard let session = session else {
            print("No mindfulness session available.")
            completion([])
            return
        }
        
        let samplePredicate = HKQuery.predicateForSamples(withStart: session.startDate, end: session.endDate, options: .strictStartDate)
        let heartbeatSeriesType = HKSeriesType.heartbeat()
        
        let query = HKSampleQuery(sampleType: heartbeatSeriesType, predicate: samplePredicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, samples, error in
            guard let samples = samples as? [HKHeartbeatSeriesSample], error == nil else {
                print("Error retrieving heartbeats: \(error!.localizedDescription)")
                completion([])
                return
            }
            
            var allHeartbeats = [TimeInterval]()
            for sample in samples {
                let heartbeatSeriesQuery = HKHeartbeatSeriesQuery(heartbeatSeries: sample) { query, timeSinceStart, precededByGap, done, error in
                    guard error == nil else {
                        print("Error querying heartbeats: \(error!.localizedDescription)")
                        return
                    }
                    allHeartbeats.append(timeSinceStart)
                    if done {
                        completion(allHeartbeats)
                    }
                }
                self.healthStore.execute(heartbeatSeriesQuery)
            }
        }
        self.healthStore.execute(query)
    }
    
}
