//
//  PastDayView.swift
//  BACCO
//
//  Created by GIF on 14/05/24.
//

import Foundation
import SwiftUI
import SwiftData
import Charts

//
//
// NUTRITION
//
//

struct PastDaysView_N: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @Query(sort: \BaccoIndexes.date) var PastDaysBaccoIndexes: [BaccoIndexes]
    @Query var saved_users: [User]
    
    @State private var expandedIndex: UUID? // Stato per tenere traccia dell'elemento espanso
    
    var body: some View {
        let calendar = Calendar.current
        let ieri = calendar.date(byAdding: .day, value: -1, to: Date())!
        
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(PastDaysBaccoIndexes) { PastDaysBaccoIndexe in
                        if !calendar.isDate(PastDaysBaccoIndexe.date, equalTo: ieri, toGranularity: .day) {
                            VStack {
                                HStack {
                                    Text(PastDaysBaccoIndexe.date, format: .dateTime.weekday(.abbreviated).day().month(.abbreviated).year())
                                    Spacer()
                                    Image(systemName: expandedIndex == PastDaysBaccoIndexe.id ? "chevron.up" : "chevron.down")
                                        .onTapGesture {
                                            withAnimation {
                                                if expandedIndex == PastDaysBaccoIndexe.id {
                                                    expandedIndex = nil
                                                } else {
                                                    expandedIndex = PastDaysBaccoIndexe.id
                                                }
                                            }
                                        }
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.12), radius: 5)
                            
                            if expandedIndex == PastDaysBaccoIndexe.id {
                                PastDayBlock_N(
                                    nutritionProgress: PastDaysBaccoIndexe.nutritionIndexes.NutritionIndexOverall,
                                    macroIndex: PastDaysBaccoIndexe.nutritionIndexes.MacronutrientsIndex,
                                    dqiIndex: PastDaysBaccoIndexe.nutritionIndexes.DietQualityIndex,
                                    carbTotal: PastDaysBaccoIndexe.nutritionIndexes.carbTotal,
                                    proteinTotal: PastDaysBaccoIndexe.nutritionIndexes.proteinTotal,
                                    fatTotal: PastDaysBaccoIndexe.nutritionIndexes.fatTotal,
                                    date: PastDaysBaccoIndexe.date
                                )
                                .transition(.opacity)
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct PastDayBlock_N: View {
    @Query var saved_users: [User]
    
    let nutritionProgress: Double
    let macroIndex: Double
    let dqiIndex: Double
    let carbTotal: Double
    let proteinTotal: Double
    let fatTotal: Double
    let date: Date
    
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
    
    var body: some View {
        let user = saved_users.last!
        
        RoundedRectangle(cornerRadius: 25.0)
            .fill(Color.white)
            .frame(width: 370, height: 350, alignment: .center)
            .shadow(color: .gray.opacity(0.12), radius: 5)
            .overlay {
                VStack {
                    Spacer(minLength: 4)
                    Text(date, format: .dateTime.month(.abbreviated).day())
                        .frame(width: 70, alignment: .leading)
                    
                    // Indice
                    HStack {
                        Spacer(minLength: 20)
                        Image(systemName: "fork.knife")
                            .resizable()
                            .scaledToFit()
                        Spacer(minLength: 1)
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
                    
                    // Macro
                    HStack(spacing: 50) {
                        VStack(spacing: 5) {
                            Text("Carb")
                                .font(.system(size: 23, weight: .light, design: .default))
                            let valueCarb = percentuali(total: carbTotal, target: user.carbTarget)
                            
                            ProgressView(value: valueCarb, total: 100.0)
                                .progressViewStyle(LinearProgressViewStyle(tint: colorForValue(Int(valueCarb))))
                                .scaleEffect(x: 1, y: 3)
                                .frame(width: 70)
                                .frame(height: 20)
                            Text("\(carbTotal, specifier: "%.0f")/ \(user.carbTarget, specifier: "%.0f") g")
                                .font(.system(size: 14, weight: .light))
                        }
                        
                        VStack(spacing: 5) {
                            Text("Protein")
                                .font(.system(size: 23, weight: .light, design: .default))
                            let valueProtein = percentuali(total: proteinTotal, target: user.proteinTarget)
                            
                            ProgressView(value: valueProtein, total: 100.0)
                                .progressViewStyle(LinearProgressViewStyle(tint: colorForValue(Int(valueProtein))))
                                .scaleEffect(x: 1, y: 3)
                                .frame(width: 70)
                                .frame(height: 20)
                            Text("\(proteinTotal, specifier: "%.0f")/ \(user.proteinTarget, specifier: "%.0f") g")
                                .font(.system(size: 14, weight: .light))
                        }
                        
                        VStack(spacing: 5) {
                            Text("Fat")
                                .font(.system(size: 23, weight: .light, design: .default))
                            let valueFat = percentuali(total: fatTotal, target: user.fatTarget)
                            
                            ProgressView(value: valueFat, total: 100.0)
                                .progressViewStyle(LinearProgressViewStyle(tint: colorForValue(Int(valueFat))))
                                .scaleEffect(x: 1, y: 3)
                                .frame(width: 70)
                                .frame(height: 20)
                            Text("\(fatTotal, specifier: "%.0f")/ \(user.fatTarget, specifier: "%.0f") g")
                                .font(.system(size: 14, weight: .light))
                        }
                    }
                    .padding()
                    
                    // DQI
                    HStack {
                        Spacer(minLength: 5)
                        VStack {
                            Text("DQI")
                                .font(.system(size: 23, weight: .light, design: .default))
                            Text("\(dqiIndex, specifier: "%.0f")/100")
                                .font(.system(size: 14, weight: .light))
                        }
                        ProgressView(value: dqiIndex, total: 100.0)
                            .progressViewStyle(LinearProgressViewStyle(tint: colorForValue(Int(dqiIndex))))
                            .scaleEffect(x: 1, y: 3, anchor: .init())
                            .frame(width: 210)
                            .padding(.horizontal, 30)
                    }
                    .padding()
                }
            }
    }
}



//
//
// MENTAL HEALTH
//
//

import SwiftUI

struct PastDaysView_MH: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @Query(sort: \BaccoIndexes.date) var PastDaysBaccoIndexes: [BaccoIndexes]
    @Query var saved_users: [User]
    
    @State private var expandedIndex: UUID?
    
    var body: some View {
        let calendar = Calendar.current
        let ieri = calendar.date(byAdding: .day, value: -1, to: Date())!
        
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(PastDaysBaccoIndexes) { PastDaysBaccoIndexe in
                        if !calendar.isDate(PastDaysBaccoIndexe.date, equalTo: ieri, toGranularity: .day) {
                            VStack {
                                HStack {
                                    Text(PastDaysBaccoIndexe.date, format: .dateTime.weekday(.abbreviated).day().month(.abbreviated).year())
                                    Spacer()
                                    Image(systemName: expandedIndex == PastDaysBaccoIndexe.id ? "chevron.up" : "chevron.down")
                                        .onTapGesture {
                                            withAnimation {
                                                if expandedIndex == PastDaysBaccoIndexe.id {
                                                    expandedIndex = nil
                                                } else {
                                                    expandedIndex = PastDaysBaccoIndexe.id
                                                }
                                            }
                                        }
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.12), radius: 5)
                            
                            if expandedIndex == PastDaysBaccoIndexe.id {
                                PastDayBlock_MH(
                                    mentalHealthProgress: PastDaysBaccoIndexe.mentalHealthIndexes.MentalHealthIndexOverall,
                                    rmssdProgress: PastDaysBaccoIndexe.mentalHealthIndexes.rmssdIndex,
                                    sdnnProgress: PastDaysBaccoIndexe.mentalHealthIndexes.sdnnIndex,
                                    date: PastDaysBaccoIndexe.date
                                )
                                .transition(.opacity)
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct PastDayBlock_MH: View {
    
    let mentalHealthProgress: Double
    let rmssdProgress: Double
    let sdnnProgress: Double
    let date: Date
    
    var body: some View {
        RoundedRectangle(cornerRadius: 25.0)
            .fill(Color.white)
            .frame(width: 370, height: 350, alignment: .center)
            .shadow(color: .gray.opacity(0.12), radius: 5)
            .overlay {
                VStack {
                    Text(date, format: .dateTime.month(.abbreviated).day())
                        .frame(width: 70, alignment: .leading)
                    
                    VStack {
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
                        HStack {
                            VStack {
                                Text("SDNN")
                                    .font(.system(size: 23, weight: .light, design: .default))
                                Text("\(sdnnProgress, specifier: "%.0f") / 100")
                                    .font(.system(size: 14, weight: .light))
                            }
                            Spacer()
                            ProgressView(value: sdnnProgress, total: 100.0)
                                .progressViewStyle(LinearProgressViewStyle(tint: colorForValue(Int(sdnnProgress))))
                                .scaleEffect(x: 1, y: 4)
                                .clipShape(RoundedRectangle(cornerRadius: 50))
                                .frame(width: 180) // Ridotta leggermente la larghezza della barra
                                .frame(height: 20)
                        }
                        
                        // RMSSD
                        HStack {
                            VStack {
                                Text("RMSSD")
                                    .font(.system(size: 23, weight: .light, design: .default))
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
                    }
                }
                .padding()
            }
    }
}




//
//
// PHYSICAL ACTIVITY
//
//

struct PastDaysView_PA: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @Query(sort: \BaccoIndexes.date) var PastDaysBaccoIndexes: [BaccoIndexes]
    @Query var saved_users: [User]
    
    @State private var expandedIndex: UUID?
    
    var body: some View {
        let calendar = Calendar.current
        let ieri = calendar.date(byAdding: .day, value: -1, to: Date())!
        
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(PastDaysBaccoIndexes) { PastDaysBaccoIndexe in
                        if !calendar.isDate(PastDaysBaccoIndexe.date, equalTo: ieri, toGranularity: .day) {
                            VStack {
                                HStack {
                                    Text(PastDaysBaccoIndexe.date, formatter: dateFormatter)
                                    Spacer()
                                    Image(systemName: expandedIndex == PastDaysBaccoIndexe.id ? "chevron.up" : "chevron.down")
                                        .onTapGesture {
                                            withAnimation {
                                                if expandedIndex == PastDaysBaccoIndexe.id {
                                                    expandedIndex = nil
                                                } else {
                                                    expandedIndex = PastDaysBaccoIndexe.id
                                                }
                                            }
                                        }
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.12), radius: 5)
                            
                            if expandedIndex == PastDaysBaccoIndexe.id {
                                PastDayBlock_PA(
                                    physicalActivityProgress: PastDaysBaccoIndexe.physicalActivityIndexes,
                                    date: PastDaysBaccoIndexe.date
                                )
                                .transition(.opacity)
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, d MMM yyyy"
        return formatter
    }
}





struct PastDayBlock_PA: View {
    let physicalActivityProgress: Double
    let date: Date
    
    var body: some View {
        RoundedRectangle(cornerRadius: 25.0)
            .fill(Color.white)
            .frame(width: 370, height: 210, alignment: .center)
            .shadow(color: .gray.opacity(0.12), radius: 5)
            .overlay {
                VStack {
                    Text(date, formatter: dateFormatter)
                        .frame(width: 70, alignment: .leading)
                    
                    VStack {
                        // PA INDEX
                        HStack(alignment: .center) {
                            Image(systemName: "figure.run")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40) // Aumenta la dimensione dell'immagine
                                .padding(.bottom, 5) // Aggiunge padding in basso per centrare con la barra
                            Spacer(minLength: 1)
                            VStack {
                                Text("\(physicalActivityProgress, specifier: "%.0f") %")
                                    .font(.system(size: 20, weight: .light, design: .default))
                                ProgressView(value: physicalActivityProgress, total: 100.0)
                                    .progressViewStyle(LinearProgressViewStyle(tint: colorForValue(Int(physicalActivityProgress))))
                                    .clipShape(RoundedRectangle(cornerRadius: 50))
                                    .scaleEffect(x: 1, y: 5, anchor: .center)
                                    .frame(width: 250)
                                    .padding(.horizontal, 20)
                            }
                        }.padding()
                    }
                }
                .padding()
            }
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter
    }
}





struct PastDaysView_BI: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @Query(sort: \BaccoIndexes.date) var PastDaysBaccoIndexes: [BaccoIndexes]
    @Query var saved_users: [User]
    @State private var expandedIndex: UUID?
    
    
    var body: some View {
        let calendar = Calendar.current
        let ieri = calendar.date(byAdding: .day, value: -1, to: Date())!
        
        RoundedRectangle(cornerRadius: 25.0)
            .fill(Color.white)
            .frame(width: 370, height: 350, alignment: .center)
            .shadow(color: .gray.opacity(0.12), radius: 5)
            .overlay {
                    VStack {
                        Text("Bacco Index Trend")
                            .font(.system(size: 20, weight: .medium, design: .default))
                            .padding()
                        
                        if PastDaysBaccoIndexes.isEmpty {
                            Spacer()
                            // Dati fittizi per mostrare gli assi anche quando l'array è vuoto
                            Text("No indexes saved")
                            Spacer()
                        } else {
                            Chart{
                                ForEach(PastDaysBaccoIndexes){ item in
                                    LineMark(
                                        x: .value("Day", item.date, unit: .day),
                                        y: .value("Index", item.baccoIndex)
                                    )
                                    .foregroundStyle(Color(hex: "#64a20d"))
                                    PointMark(
                                        x: .value("Day", item.date, unit: .day),
                                        y: .value("Index", item.baccoIndex)
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
        ForEach(PastDaysBaccoIndexes) { PastDaysBaccoIndexe in
            if !calendar.isDate(PastDaysBaccoIndexe.date, equalTo: ieri, toGranularity: .day) {
                VStack {
                    HStack {
                        Text(PastDaysBaccoIndexe.date, formatter: dateFormatter)
                        Spacer()
                        Image(systemName: expandedIndex == PastDaysBaccoIndexe.id ? "chevron.up" : "chevron.down")
                            .onTapGesture {
                                withAnimation {
                                    if expandedIndex == PastDaysBaccoIndexe.id {
                                        expandedIndex = nil
                                    } else {
                                        expandedIndex = PastDaysBaccoIndexe.id
                                    }
                                }
                            }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray.opacity(0.12), radius: 5)
                
                if expandedIndex == PastDaysBaccoIndexe.id {
                    PastDayBlock_BI(
                        BaccoIndex: PastDaysBaccoIndexe.baccoIndex,
                        date: PastDaysBaccoIndexe.date
                    )
                    .transition(.opacity)
                }
            }
        }
    }
    
    var startOfWeek: Date {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let weekday = calendar.component(.weekday, from: today)
        return calendar.date(byAdding: .day, value: -weekday + calendar.firstWeekday, to: today)!
    }
    
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, d MMM yyyy"
        return formatter
    }
    
}


struct PastDayBlock_BI: View {
    let BaccoIndex: Double
    let date: Date
    
    var body: some View {
        RoundedRectangle(cornerRadius: 25.0)
            .fill(Color.white)
            .frame(width: 370, height: 210, alignment: .center)
            .shadow(color: .gray.opacity(0.12), radius: 5)
            .overlay {
                VStack {
                    Text(date, formatter: dateFormatter)
                        .frame(width: 70, alignment: .leading)

                    VStack {
                        // BACCO INDEX
                        HStack(alignment: .center) {
                            Image("Image")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .padding(.bottom, 5)
                            Spacer(minLength: 1)
                            VStack {
                                Text("\(BaccoIndex, specifier: "%.0f") %")
                                    .font(.system(size: 20, weight: .light, design: .default))
                                ProgressView(value: BaccoIndex, total: 100.0)
                                    .progressViewStyle(LinearProgressViewStyle(tint: colorForValue(Int(BaccoIndex))))
                                    .clipShape(RoundedRectangle(cornerRadius: 50))
                                    .scaleEffect(x: 1, y: 5, anchor: .center)
                                    .frame(width: 250)
                                    .padding(.horizontal, 20)
                            }
                        }.padding()
                    }
                }
                .padding()
            }
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter
    }
}
