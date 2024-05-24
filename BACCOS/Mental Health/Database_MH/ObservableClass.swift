//
//  ObservableClass.swift
//  BACCO
//
//  Created by GIF on 10/05/24.
//

import Foundation
import Observation

@Observable class HeartbeatViewModel {
    var heartbeats: [TimeInterval] = []
    var intervals: [Double] = []
    var recentHeartRates: [Double] = []  // Ultimi 7 valori del battito cardiaco a riposo
    private var healthKitManager = HealthKitManager(heartRateData: [])

    init(heartbeats: [TimeInterval], intervals: [Double], recentHeartRates: [Double] = [], healthKitManager: HealthKitManager = HealthKitManager(heartRateData: [])) {
        self.heartbeats = heartbeats
        self.intervals = intervals
        self.recentHeartRates = recentHeartRates
        self.healthKitManager = healthKitManager
    }

    func loadHeartbeatData(completion: @escaping () -> Void) {
        healthKitManager.retrieveFirstDailyMindfulnessSession() { [weak self] session in
            guard let self = self, let session = session else {
                DispatchQueue.main.async {
                    completion()  // Chiamo la closure di completamento anche in caso di errore o mancanza di dati
                }
                self!.intervals = []
                return
            }

            self.healthKitManager.retrieveBeatToBeatDataForMindfulnessSession(session: session) { heartbeats in
                DispatchQueue.main.async {
                    self.heartbeats = heartbeats
                    self.calculateIntervals()
                    completion()  // Chiamo la closure di completamento qui
                }
            }
        }
    }
    
    func loadRestingHeartRate(completion: @escaping () -> Void) {
        healthKitManager.fetchLastSevenRestingHeartRates { [weak self] (restingHRs, error) in
            DispatchQueue.main.async {
                if let restingHRs = restingHRs, !restingHRs.isEmpty {
                    self?.recentHeartRates = restingHRs
                    print("Resting heart rates updated: \(restingHRs)")
                } else if let error = error {
                    print("Error fetching resting heart rates: \(error.localizedDescription)")
                }
                completion() // Chiamo la closure di completamento indipendentemente dall'esito
            }
        }
    }

    private func calculateIntervals() {
        guard heartbeats.count > 1 else { return }
        
        intervals = []
        for i in 0..<heartbeats.count - 1 {
            let interval = heartbeats[i + 1] - heartbeats[i]
            if interval < 1.3 {
                intervals.append(interval * 1000) // Converto in millisecondi
            }
        }
    }
}
