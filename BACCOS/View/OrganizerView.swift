//
//  OrganizerView.swift
//  BACCO
//
//  Created by GIF on 15/05/24.
//

import SwiftData
import SwiftUI
import Foundation

struct OrganizerView: View {
    @Environment(\.modelContext) var context
    @Query var saved_users: [User]
    @Query var HRV_Metrics: [HRVMetrics]

    var body: some View {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // Find the most recent date in HRV_Metrics
        let mostRecentHRVDate: Date? = HRV_Metrics.map { $0.date }.max()
        
        // Check if the most recent date is different from today
        let isDifferentFromToday: Bool = {
            if let mostRecentHRVDate = mostRecentHRVDate {
                return !calendar.isDate(mostRecentHRVDate, inSameDayAs: today)
            }
            return true
        }()
        
        VStack {
            if saved_users.isEmpty {
                WelcomeView()
            } else if HRV_Metrics.isEmpty {
                MindfulnessView()
            } else {
                if isDifferentFromToday {
                    FirstView()
                } else {
                    ProvaView()
                }
            }
        }
    }
}
