//
//  PhysicalActivityView.swift
//  BACCO
//
//  Created by GIF on 14/05/24.
//

import Foundation
import SwiftData
import SwiftUI
import Charts

struct PhysicalActivityView: View {
    @Query var physicalActivityIndexes: [BaccoIndexes]
    @Query var punteggio: [Punteggio]
    @Query var saved_users: [User]
    @State private var isExpandedPhysicalActivity = false
    @State private var tooltipIsVisible = false
    @State private var selectedDataPoint: DataPoint? = nil
    
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var showMMInfo = false
    @State private var showVMInfo = false
    @State private var showWTInfo = false

    var body: some View {
        let physicalActivityProgress = physicalActivityIndexes.last?.physicalActivityIndexes ?? 0.0
        let moderateMinutes = punteggio.last?.MVPACounter.MPACounter ?? 0
        let vigorousMinutes = punteggio.last?.MVPACounter.VPACounter ?? 0
        
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    SummaryCard(physicalActivityProgress: physicalActivityProgress, moderateMinutes: moderateMinutes, vigorousMinutes: vigorousMinutes)
                    WeeklyTrendCard()
                    ChartCard(physicalActivityIndexes: physicalActivityIndexes)
                    
                    NavigationLink(destination: PastDaysView_PA()) {
                        Text("Show Previous Days")
                            .foregroundColor(Color.black)
                    }
                    
                    //
                    // DisclosureGroup for Physical Activity
                    //
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
                    
                    
                }
            }
            .padding()
            .background(Color.gray.opacity(0.05).ignoresSafeArea())
            .navigationTitle("Physical Activity Index")
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    BottomToolbar()
                }
            }
        }
    }
    
    
    @ViewBuilder
    private func SummaryCard(physicalActivityProgress: Double, moderateMinutes: Int, vigorousMinutes: Int) -> some View {
        RoundedRectangle(cornerRadius: 25.0)
            .fill(Color.white)
            .frame(width: 370, height: 350, alignment: .center)
            .shadow(color: .gray.opacity(0.12), radius: 5)
            .overlay {
                VStack {
                    Text("How did you do yesterday?")
                        .font(.system(size: 25, weight: .medium, design: .default))
                    
                    VStack(alignment: .leading, spacing: 20) {
                        // PA INDEX OVERALL
                        HStack(alignment: .center) {
                            Image(systemName: "figure.run")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .padding(.bottom, 5)
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
                        
                        // MODERATE MINUTES
                        HStack(alignment: .center) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Moderate Minutes")
                                        .font(.system(size: 23, weight: .light, design: .default))
                                    Button(action: {
                                        showMMInfo = true
                                    }) {
                                        Image(systemName: "info.circle")
                                            .foregroundColor(Color(hex: "#64a20d"))
                                    }
                                    .alert(isPresented: $showMMInfo) {
                                        Alert(title: Text("Moderate Minutes Info"), message: Text("Moderate minutes are the time spent at 64-76% of the maximum heart rate during a workout."), dismissButton: .default(Text("Got it!")))
                                    }
                                }
                                Text("\(moderateMinutes) minutes")
                                    .font(.system(size: 14, weight: .light))
                            }
                            Spacer()
                        }.padding(.horizontal, 20)
                        
                        // VIGOROUS MINUTES
                        HStack(alignment: .center) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Vigorous Minutes")
                                        .font(.system(size: 23, weight: .light, design: .default))
                                    Button(action: {
                                        showVMInfo = true
                                    }) {
                                        Image(systemName: "info.circle")
                                            .foregroundColor(Color(hex: "#64a20d"))
                                    }
                                    .alert(isPresented: $showVMInfo) {
                                        Alert(title: Text("Vigorous Minutes Info"), message: Text("Vigorous minutes are the time spent at 77-93% of the maximum heart rate during a workout. One minute of vigorous activity is equivalent to two minuts of moderate activity"), dismissButton: .default(Text("Got it!")))
                                    }
                                }
                                Text("\(vigorousMinutes) minutes")
                                    .font(.system(size: 14, weight: .light))
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding()
            }
    }
    
    
    @ViewBuilder
    private func WeeklyTrendCard() -> some View {
        //var selectedPoint: DataPoint? = nil
        let user = saved_users.last!
        let weeklygoal = WeeklyGoal(lpa: user.lpa)
        
        VStack {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Color.white)
                .frame(width: 370, height: 350, alignment: .center)
                .shadow(color: .gray.opacity(0.12), radius: 5)
                .overlay {
                    VStack() {
                        HStack{
                            Text("Weekly Trend")
                                .font(.system(size: 20, weight: .medium, design: .default))
                                .padding(.top)
                            // necessario per la costruzione del grafico dell'andamento ideale
                            
                            Button(action: {
                                showWTInfo = true
                            }) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(Color(hex: "#64a20d"))
                            }
                            .alert(isPresented: $showWTInfo) {
                                Alert(title: Text("Weekly Trend Chart"), message: Text("The chart compares the ideal trend (blue line) that you should have to reach your weekly physical activity goal with your actual trend (green line). The index is given as the ratio between the values of the two lines on the same day. Graphically, if the actual trend is above the ideal trend on a given day, the score will be highest. Remember, it is not necessary to exercise every day; what is important is reaching the weekly goal."), dismissButton: .default(Text("Got it!")))
                            }.padding(.top)
                        }

                        let idealdata = (1...7).map {
                            DataPoint(type: "Ideal", day: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"][$0 - 1], points:
                                        weeklygoal/7 * Double($0))
                        }
                        // Popolamento dell'array di punti accumulati utilizzando la funzione CalcoloAccumulatedPoints
                        let punti_accumulati = CalcoloAccumulatedPoints(context: context)
                        // Utilizza punti_accumulatiMapped invece di punti_accumulati
                        let punti_accumulatiMapped = punti_accumulati.map { DataPoint(type: "Real" ,day: $0.day, points: $0.points) }
                        // Unione degli array idealData e punti_accumulatiMapped
                        let combinedData = idealdata + punti_accumulatiMapped
                        
                        //let typeColors: [String: Color] = [
                        //    "Ideal": .black,
                        //    "Real": Color(hex: "#62a230")
                        //]

                        
                        Spacer()
                        
                        GeometryReader { geometry in
                            
                            VStack {
                                Chart(combinedData){ data in
                                    LineMark(
                                        x: .value("Day", data.day), // Valore sull'asse X (giorno della settimana)
                                        y: .value("Points", data.points) // Valore sull'asse Y (punti)
                                    )
                                    .foregroundStyle(by: .value("Type", data.type)) // Colore della linea
                                    //.foregroundStyle(typeColors[data.type, default: .black])
                                    PointMark(
                                        x: .value("Day", data.day),
                                        y: .value("Points", data.points)
                                    )
                                    .foregroundStyle(by: .value("Type", data.type))
                                    //.foregroundStyle(typeColors[data.type, default: .black])
                                }
                                
                                .chartXAxis {
                                    AxisMarks(position: .bottom)
                                    // Imposta l'asse X nella parte inferiore del grafico
                                }
                                .chartYScale(domain: [0, weeklygoal + 50])
                                .chartYAxis {
                                    AxisMarks(position: .leading) // Imposta l'asse Y a sinistra del grafico
                                }
                                // specifiche per il grafico
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                
                                //.frame(width: geometry.size.width, height: geometry.size.height) // Fissa le dimensioni del grafico
                                
                                .chartOverlay { proxy in
                                    GeometryReader { geometry in
                                        Rectangle()
                                            .fill(Color.clear)
                                            .contentShape(Rectangle())
                                            .gesture(
                                                DragGesture(minimumDistance: 0)
                                                    .onEnded { value in
                                                        let location = value.location
                                                        print("Tap location: \(location)") // Debug print
                                                        
                                                        detectDataPoint(location: location, proxy: proxy, geometry: geometry, combinedData: combinedData)
                                                    }
                                            )
                                    }
                                }
                            }
                            // Spacer() // Spazio per il tooltip
                        }
                        .padding([.leading, .trailing])
                        .frame(height: 220) // Altezza fissa per il contenitore del grafico
                        
                        Spacer().frame(height: 10) // Spazio extra tra il grafico e il tooltip
                        
                        if let selectedDataPoint = selectedDataPoint, tooltipIsVisible {
                            Text("Value: \(selectedDataPoint.points, specifier: "%.0f")")
                                .padding()
                                .background(Color.white)
                                .cornerRadius(5)
                                .shadow(radius: 3)
                                .transition(.opacity)
                                .animation(.easeInOut, value: tooltipIsVisible)
                            // .zIndex(1) // Imposta un valore zIndex alto per il tooltip
                        } else {
                            Spacer() // Spazio fisso per il tooltip anche quando non è visibile
                                .frame(height: 50)
                        }
                        
                    }
                    .padding()
                }
        }
    }
                
            
    

    
    private func detectDataPoint(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy, combinedData: [DataPoint]) {
            let x = location.x - geometry[proxy.plotFrame!].origin.x
            let y = location.y - geometry[proxy.plotFrame!].origin.y
        print("Converted location: x = \(x), y = \(y)") // Debug print

            if let xValue: String = proxy.value(atX: x),
               let yValue: Double = proxy.value(atY: y) {
                print("xValue: \(xValue), yValue: \(yValue)") // Debug print

                // Tolleranza per il confronto dei valori Y
                let tolerance: Double = 10.0
                
                if let dataPoint = combinedData.first(where: { $0.day == xValue && abs($0.points - yValue) < tolerance }){
                    selectedDataPoint = dataPoint
                    tooltipIsVisible = true
                    print("Selected data point: \(dataPoint)") // Debug print

                } else {
                    tooltipIsVisible = false
                    print("No matching data point found") // Debug print

                }
            } else {
                tooltipIsVisible = false
                print("Invalid xValue or yValue") // Debug print

            }
        }
    
    @ViewBuilder
    private func ChartCard(physicalActivityIndexes: [BaccoIndexes]) -> some View {
        RoundedRectangle(cornerRadius: 25.0)
            .fill(Color.white)
            .frame(width: 370, height: 350, alignment: .center)
            .shadow(color: .gray.opacity(0.12), radius: 5)
            .overlay {
                VStack {
                    Text("Physical Activity Index Trend")
                        .font(.system(size: 20, weight: .medium, design: .default))
                        .padding()
                    
                    if physicalActivityIndexes.isEmpty {
                        Spacer()
                        // Dati fittizi per mostrare gli assi anche quando l'array è vuoto
                        Text("No indexes saved")
                        Spacer()
                    } else {
                        Chart{
                            ForEach(physicalActivityIndexes) { item in
                                LineMark(
                                    x: .value("Day", item.date, unit: .day),
                                    y: .value("Index", item.physicalActivityIndexes)
                                )
                                .foregroundStyle(Color(hex: "#64a20d"))
                                PointMark(
                                    x: .value("Day", item.date, unit: .day),
                                    y: .value("Index", item.physicalActivityIndexes)
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
    PhysicalActivityView()
}
