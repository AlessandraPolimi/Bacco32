//
//  MentalHealthView.swift
//  BACCO
//
//  Created by GIF on 14/05/24.
//

import Foundation
import SwiftData
import SwiftUI
import Charts


struct MentalHealthView: View {
    @Query var mentalHealthIndexes: [BaccoIndexes]
    @Query var saved_users: [User]
    @State private var isExpandedMentalHealth = false
    
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var showSDNNInfo = false
    @State private var showRMSSDInfo = false
    
    var body: some View {
        let mentalHealthProgress = mentalHealthIndexes.last?.mentalHealthIndexes.MentalHealthIndexOverall ?? 0.0
        let rmssdProgress = mentalHealthIndexes.last?.mentalHealthIndexes.rmssdIndex ?? 0.0
        let sdnnProgress = mentalHealthIndexes.last?.mentalHealthIndexes.sdnnIndex ?? 0.0
        
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    SummaryCard(mentalHealthProgress: mentalHealthProgress, rmssdProgress: rmssdProgress, sdnnProgress: sdnnProgress)
                    ChartCard(mentalHealthIndexes: mentalHealthIndexes)
                    
                    NavigationLink(destination: PastDaysView_MH()) {
                        Text("Show Previous Days")
                            .foregroundColor(Color.black)
                    }
                    
                    //
                    // DisclosureGroup for Mental Health
                    //
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
            }
            .padding()
            .background(Color.gray.opacity(0.05).ignoresSafeArea())
            .navigationTitle("Mental Health Index")
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    BottomToolbar()
                }
            }
            .alert("SDNN Information", isPresented: $showSDNNInfo, actions: {}, message: {
                Text("SDNN stands for Standard Deviation of NN intervals and is a measure of heart rate variability, reflecting a systemic representation of mental health.")
            })
            .alert("RMSSD Information", isPresented: $showRMSSDInfo, actions: {}, message: {
                Text("RMSSD stands for Root Mean Square of Successive Differences and is a measure of heart rate variability, strongly correlated with the parasympathetic nervous system.")
            })
        }
    }
    
    @ViewBuilder
    private func SummaryCard(mentalHealthProgress: Double, rmssdProgress: Double, sdnnProgress: Double) -> some View {
        RoundedRectangle(cornerRadius: 25.0)
            .fill(Color.white)
            .frame(width: 370, height: 350, alignment: .center)
            .shadow(color: .gray.opacity(0.12), radius: 5)
            .overlay {
                VStack {
                    Text("How did you do yesterday?")
                        .font(.system(size: 25, weight: .medium, design: .default))
                    
                    VStack(alignment: .leading, spacing: 20) {
                        // MH INDEX OVERALL
                        HStack(alignment: .center) {
                            Image(systemName: "brain.head.profile")
                                 .resizable()
                                 .scaledToFit()
                                 .frame(width: 40, height: 40) // Aumenta la dimensione dell'immagine
                                 .padding(.bottom, 5) // Aggiunge padding in basso per centrare con la barra
                            Spacer(minLength: 1)
                            VStack {
                                Text("\(mentalHealthProgress, specifier: "%.0f") %")
                                    .font(.system(size: 20, weight: .light, design: .default))
                                ProgressView(value: mentalHealthProgress, total: 100.0)
                                    .progressViewStyle(LinearProgressViewStyle(tint: colorForValue(Int(mentalHealthProgress))))
                                    .clipShape(RoundedRectangle(cornerRadius: 50))
                                    .scaleEffect(x: 1, y: 5, anchor: .center)
                                    .frame(width: 250)
                                    .padding(.horizontal, 20)
                            }
                        }.padding()
                        
                        // SDNN
                        HStack(alignment: .center) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("SDNN")
                                        .font(.system(size: 23, weight: .light, design: .default))
                                    Button(action: {
                                        showSDNNInfo = true
                                    }) {
                                        Image(systemName: "info.circle")
                                            .foregroundColor(Color(hex: "#64a20d"))
                                    }
                                }
                                Text("\(sdnnProgress, specifier: "%.0f") / 100")
                                    .font(.system(size: 14, weight: .light))
                            }
                            Spacer()
                            ProgressView(value: sdnnProgress, total: 100.0)
                                .progressViewStyle(LinearProgressViewStyle(tint: colorForValue(Int(sdnnProgress))))
                                .scaleEffect(x: 1, y: 4)
                                .clipShape(RoundedRectangle(cornerRadius: 50))
                                .frame(width: 180) 
                                .frame(height: 20)
                        }
                        .padding(.horizontal, 20)
                        
                        // RMSSD
                        HStack(alignment: .center) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("RMSSD")
                                        .font(.system(size: 23, weight: .light, design: .default))
                                    Button(action: {
                                        showRMSSDInfo = true
                                    }) {
                                        Image(systemName: "info.circle")
                                            .foregroundColor(Color(hex: "#64a20d"))
                                    }
                                }
                                Text("\(rmssdProgress, specifier: "%.0f") / 100")
                                    .font(.system(size: 14, weight: .light))
                            }
                            Spacer()
                            ProgressView(value: rmssdProgress, total: 100.0)
                                .progressViewStyle(LinearProgressViewStyle(tint: colorForValue(Int(rmssdProgress))))
                                .scaleEffect(x: 1, y: 3)
                                .clipShape(RoundedRectangle(cornerRadius: 50))
                                .frame(width: 180) // Ridotta leggermente la larghezza della barra
                                .frame(height: 20)
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding()
            }
    }
    
    
    //@ViewBuilder
    //private func ChartCard(mentalHealthIndexes: [BaccoIndexes]) -> some View {
    //    RoundedRectangle(cornerRadius: 25.0)
    //        .fill(Color.white)
    //        .frame(width: 370, height: 350, alignment: .center)
    //        .shadow(color: .gray.opacity(0.12), radius: 5)
    //        .overlay {
    //            VStack {
    //                Text("Mental Health Index Trend")
    //                    .font(.system(size: 20, weight: .medium, design: .default))
    //                    .padding()
    //
    //                Chart {
    //                    if mentalHealthIndexes.isEmpty {
    //                        // Dati fittizi per mostrare gli assi anche quando l'array è vuoto
    //                        LineMark(
    //                            x: .value("Day", Date()),
    //                            y: .value("Index", 0.0)
    //                        )
    //                        .foregroundStyle(Color.clear) // Linea trasparente
    //                    } else {
    //                        ForEach(mentalHealthIndexes) { item in
    //                            LineMark(
    //                                x: .value("Day", item.date, unit: .day),
    //                                y: .value("Index", item.mentalHealthIndexes.MentalHealthIndexOverall)
    //                            )
    //                            .foregroundStyle(Color.blue)
    //                        PointMark(
    //                                x: .value("Day", item.date, unit: .day),
    //                                y: .value("Index", item.mentalHealthIndexes.MentalHealthIndexOverall)
    //                            )
    //                            .foregroundStyle(Color.blue)
    //                        }
    //                    }
    //                }
    //                .chartXAxis {
    //                    AxisMarks(values: stride(from: 0, to: 7, by: 1).map { Calendar.current.date(byAdding: .day, value: $0, to: startOfWeek) ?? //Date() }) { value in
    //                        AxisGridLine()
    //                        AxisTick()
    //                        AxisValueLabel(format: .dateTime.weekday(), centered: true)
    //                    }
    //                }
    //                .chartYAxis {
    //                    AxisMarks(values: Array(stride(from: 0, to: 101, by: 20))) { value in
    //                        AxisGridLine()
    //                        AxisTick()
    //                        AxisValueLabel()
    //                    }
    //                }
    //                .padding()
    //            }
    //        }
    //    var startOfWeek: Date {
    //        let calendar = Calendar.current
    //        let today = calendar.startOfDay(for: Date())
    //        let weekday = calendar.component(.weekday, from: today)
    //        return calendar.date(byAdding: .day, value: -weekday + calendar.firstWeekday, to: today)!
    //    }
    //}
    
    @ViewBuilder
    private func ChartCard(mentalHealthIndexes: [BaccoIndexes]) -> some View {
        RoundedRectangle(cornerRadius: 25.0)
            .fill(Color.white)
            .frame(width: 370, height: 350, alignment: .center)
            .shadow(color: .gray.opacity(0.12), radius: 5)
            .overlay {
                VStack {
                    Text("Mental Health Index Trend")
                        .font(.system(size: 20, weight: .medium, design: .default))
                        .padding()
                    
            if mentalHealthIndexes.isEmpty {
                    Spacer()
                    // Dati fittizi per mostrare gli assi anche quando l'array è vuoto
                    Text("No indexes saved")
                    Spacer()
                
                        } else {
                            Chart{
                            ForEach(mentalHealthIndexes) { item in
                                LineMark(
                                    x: .value("Day", item.date, unit: .day),
                                    y: .value("Index", item.mentalHealthIndexes.MentalHealthIndexOverall)
                                )
                                .foregroundStyle(Color(hex: "#64a20d"))
                                PointMark(
                                    x: .value("Day", item.date, unit: .day),
                                    y: .value("Index", item.mentalHealthIndexes.MentalHealthIndexOverall)
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


#Preview {
    MentalHealthView()
}
