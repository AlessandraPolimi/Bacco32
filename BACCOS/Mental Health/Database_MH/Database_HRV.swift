//
//  Database_HRV.swift
//  BACCO
//
//  Created by GIF on 10/05/24.
//

import Foundation
import SwiftData

@Model
class HRVMetrics {
    var rmssd: Double
    var sdnn: Double
    var date: Date
    
    init(rmssd: Double, sdnn: Double, date: Date) {
        self.rmssd = rmssd
        self.sdnn = sdnn
        self.date = date
    }
}

/*
struct PhysiologicalRange {
    let SDNNmin = 13.9
    let SDNNmax = 161.4
    let RMSSDmin = 16.0
    let RMSSDmax = 182.7
}
*/
/*
@Model
class MetricsDatabase {
    var RMSSDscore: Int
    var SDNNscore: Int
    var date: Date
    
    init(RMSSDscore: Int, SDNNscore: Int, date: Date) {
        self.RMSSDscore = RMSSDscore
        self.SDNNscore = SDNNscore
        self.date = date
    }
}
*/
