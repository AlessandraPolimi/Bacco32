//
//  NewNutritionView.swift
//  BACCO
//
//  Created by GIF on 13/05/24.
//

import Foundation
import SwiftUI
import SwiftData
import Charts


struct NewNutritionView: View {
    @Query var nutritionIndexes: [BaccoIndexes]
    @Query var saved_users: [User]
    @State private var isExpandedNutrition = false
    @State private var showDQIAlert = false
    
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        let nutritionProgress = nutritionIndexes.last?.nutritionIndexes.NutritionIndexOverall ?? 0.0
        let dqiIndex = nutritionIndexes.last?.nutritionIndexes.DietQualityIndex ?? 0.0
        let carbTotal = nutritionIndexes.last?.nutritionIndexes.carbTotal ?? 0.0
        let proteinTotal = nutritionIndexes.last?.nutritionIndexes.proteinTotal ?? 0.0
        let fatTotal = nutritionIndexes.last?.nutritionIndexes.fatTotal ?? 0.0
        let user = saved_users.last!
        
        
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    SummaryCard(nutritionProgress: nutritionProgress, carbTotal: carbTotal, proteinTotal: proteinTotal, fatTotal: fatTotal, dqiIndex: dqiIndex, user: user, showDQIAlert: $showDQIAlert)
                    ChartCard(nutritionIndexes: nutritionIndexes)
                    
                    NavigationLink(destination: PastDaysView_N()) {
                        Text("Show Previous Days")
                            .foregroundColor(Color.black)
                    }

                    
                    //
                    // Custom DisclosureGroup for Nutrition
                    //
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
                    
                    
                }
            }
            .padding()
            .background(Color.gray.opacity(0.05).ignoresSafeArea())
            .navigationTitle("Nutrition Index")
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    BottomToolbar()
                }
            }
        }
    }
    
    private func percentuali(total: Double, target: Double) -> Double {
        var value = 0.0
        let percentage = (total / target) * 100
        if percentage <= 100 {
            value = percentage
        } else {
            value = 200 - percentage
            if value < 0 {
                value = 0
            }
        }
        return value
    }
    
    @ViewBuilder
    private func SummaryCard(nutritionProgress: Double, carbTotal: Double, proteinTotal: Double, fatTotal: Double, dqiIndex: Double, user: User, showDQIAlert: Binding<Bool>) -> some View {
        RoundedRectangle(cornerRadius: 25.0)
            .fill(Color.white)
            .frame(width: 370, height: 350, alignment: .center)
            .shadow(color: .gray.opacity(0.12), radius: 5)
            .overlay {
                VStack {
                    Spacer(minLength: 4)
                    Text("How did you do yesterday?")
                        .font(.system(size: 25, weight: .medium, design: .default))
                    
                    HStack {
                        Spacer(minLength: 20)
                        
                        Image(systemName: "fork.knife")
                            .resizable()
                            .scaledToFit()
                        
                        VStack {
                            Text("\(nutritionProgress, specifier: "%.0f") %")
                                .font(.system(size: 20, weight: .light, design: .default))
                            
                            ProgressView(value: nutritionProgress, total: 100.0)
                                .progressViewStyle(LinearProgressViewStyle(tint: colorForValue(Int(nutritionProgress))))
                                .clipShape(RoundedRectangle(cornerRadius: 50))
                                .scaleEffect(x: 1, y: 5, anchor: .center)
                                .frame(width: 250)
                                .padding(.horizontal, 20)
                        }
                    }
                    .padding()
                    
                    HStack(spacing: 50) {
                        MacroCard(title: "Carb", total: carbTotal, target: user.carbTarget)
                        MacroCard(title: "Protein", total: proteinTotal, target: user.proteinTarget)
                        MacroCard(title: "Fat", total: fatTotal, target: user.fatTarget)
                    }
                    .padding()
                    
                    HStack {
                        VStack {
                            HStack {
                                Text("DQI")
                                    .font(.system(size: 23, weight: .light, design: .default))
                                
                                Button(action: {
                                    showDQIAlert.wrappedValue = true
                                }) {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(Color(hex: "#64a20d"))
                                }
                                .alert(isPresented: showDQIAlert) {
                                    Alert(title: Text("DQI Information"), message: Text("The Diet Quality Index (DQI) - International is a measure of diet quality based on variety, adequacy, moderation, and balance."), dismissButton: .default(Text("Got it!")))
                                }
                            }
                            Text("\(dqiIndex, specifier: "%.0f")/100")
                                .font(.system(size: 14, weight: .light))
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                        ProgressView(value: dqiIndex, total: 100.0)
                            .progressViewStyle(LinearProgressViewStyle(tint: colorForValue(Int(dqiIndex))))
                            .scaleEffect(x: 1, y: 3, anchor: .init())
                            .frame(width: 210)
                            .padding(.horizontal, 10)
                    }
                    .padding()
                }
            }
    }
    
    @ViewBuilder
    private func MacroCard(title: String, total: Double, target: Double) -> some View {
        let value = percentuali(total: total, target: target)
        
        VStack(spacing: 5) {
            Text(title)
                .font(.system(size: 23, weight: .light, design: .default))
            
            ProgressView(value: value, total: 100.0)
                .progressViewStyle(LinearProgressViewStyle(tint: colorForValue(Int(value))))
                .scaleEffect(x: 1, y: 3)
                .presentationCornerRadius(10)
                .frame(width: 70)
                .frame(height: 20)
            Text("\(total, specifier: "%.0f")/ \(target, specifier: "%.0f") g")
                .font(.system(size: 14, weight: .light))
        }
    }
    
    
    
    @ViewBuilder
    private func ChartCard(nutritionIndexes: [BaccoIndexes]) -> some View {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Color.white)
                .frame(width: 370, height: 350, alignment: .center)
                .shadow(color: .gray.opacity(0.12), radius: 5)
                .overlay {
                    VStack {
                        Text("Nutrition Index Trend")
                            .font(.system(size: 20, weight: .medium, design: .default))
                            .padding()
                    
                        if nutritionIndexes.isEmpty {
                            Spacer()
                            // Dati fittizi per mostrare gli assi anche quando l'array è vuoto
                            Text("No indexes saved")
                            Spacer()
                        } else {
                            Chart{
                                ForEach(nutritionIndexes) { item in
                                    LineMark(
                                        x: .value("Day", item.date, unit: .day),
                                        y: .value("Index", item.nutritionIndexes.NutritionIndexOverall)
                                    )
                                    .foregroundStyle(Color(hex: "#64a20d"))
                                    PointMark(
                                        x: .value("Day", item.date, unit: .day),
                                        y: .value("Index", item.nutritionIndexes.NutritionIndexOverall)
                                    )
                                    .foregroundStyle(Color(hex: "#64a20d"))
                                }
                            }.chartYScale(domain: [0, 100])
                            .chartXAxis {
                                AxisMarks(position: .bottom, values: .stride(by: .day)) { _ in
                                    AxisValueLabel(format: .dateTime.weekday(.short))
                                }
                            }
                            .chartYAxis {
                                AxisMarks(position: .leading, values: Array(stride(from: 0, to: 101, by: 20))){
                                    AxisGridLine()
                                    AxisTick()
                                    AxisValueLabel()
                                }
                            }
                            .padding()
                        }
                    }
                }
        
        var startOfWeek: Date {
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let weekday = calendar.component(.weekday, from: today)
            return calendar.date(byAdding: .day, value: -weekday + calendar.firstWeekday, to: today)!
        }
    }
    
    
    @ViewBuilder
    private func BottomToolbar() -> some View {
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


#Preview{
    NewNutritionView()
}

extension Color {
    static let customGreen = Color(red: 155/255, green: 207/255, blue: 83/255)
}
