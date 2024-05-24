//
//  File.swift
//  BACCO
//
//  Created by GIF on 16/05/24.
//

import Foundation
import SwiftData
import SwiftUI

struct NewUserView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    @State private var navigateToMindfulnessCounterView = false
    
    @State private var name: String = ""
    @State private var birthDate: Date = Date()
    @State private var height: Double = 0.0
    @State private var weight: Double = 0.0
    @State private var sesso = Sesso.Maschio
    @State private var lpa = LivelloPA.Sedentary
    
    @Query var saved_users: [User]
    @State private var showingDatePicker = false
    @State private var navigateToMindfulness = false
    @State private var showingPALInfo = false 

    var body: some View {

        let age = Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year ?? 0
        
        NavigationStack {
            VStack(spacing: 20) {
                Spacer(minLength: 20)
                
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(Color(hex: "#64a20d"))
                
                Text("Create Your Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(spacing: 15) {
                    TextField("Name", text: $name)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    
                    HStack {
                        Text("Date of birth:")
                            .foregroundColor(.secondary)
                        Spacer()
                        Button(action: {
                            showingDatePicker.toggle()
                        }) {
                            Text("\(birthDate, formatter: dateFormatter)")
                                .foregroundColor(Color(hex: "#64a20d"))
                        }
                        .sheet(isPresented: $showingDatePicker) {
                            VStack {
                                DatePicker("Date of birth", selection: $birthDate, displayedComponents: .date)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                    .accentColor(Color(hex: "#64a20d"))
                                    .padding()
                                Button("Done") {
                                    showingDatePicker = false
                                }
                                .padding()
                            }
                        }
                        
                    }
                    
                    
                    TextField("Height (cm)", text: Binding<String>(
                        get: {
                            self.height != 0 ? String(self.height) : ""
                        },
                        set: {
                            self.height = Double($0) ?? 0.0
                        }
                    ))
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    
                    TextField("Weight (kg)", text: Binding<String>(
                        get: {
                            self.weight != 0 ? String(self.weight) : ""
                        },
                        set: {
                            self.weight = Double($0) ?? 0.0
                        }
                    ))
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    
                    Picker("Sex", selection: $sesso) {
                        ForEach(Sesso.allCases, id: \.self) { sesso in
                            Text(sesso.descr).tag(sesso)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    // Sezione per il livello di attività fisica
                    HStack {
                        Text("Physical Activity Level:")
                            .foregroundColor(.secondary)
                        Spacer()
                        Picker(selection: $lpa, label: Text("")) {
                            ForEach(LivelloPA.allCases, id: \.self) { lpa in
                                Text(lpa.descr)
                                    .foregroundColor(Color(hex: "#64a20d"))
                                    .tag(lpa)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        
                        Button(action: {
                            showingPALInfo.toggle()
                        }) {
                            Image(systemName: "info.circle")
                                .foregroundColor(Color(hex: "#64a20d"))
                        }
                        .alert(isPresented: $showingPALInfo) {
                            Alert(
                                title: Text("Information about PAL"),
                                message: Text("**PAL (Physical Activity Level)** is a measure that quantifies an individual's overall level of physical activity.\n**ExtraPAL:** twice a day (hard work)\n**HighPAL:** 6-7 times a week\n**ModeratePAL:** 3-5 times a week\n**LowPAL:** 1-3 times a week\n**Sedentary:** very low"),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                        .padding(.leading, 8)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                .padding(.horizontal, 20)
                
                // Pulsante Save separato
                Button(action: {
                    saveUserAndCalculate(context: context)
                    navigateToMindfulness = true
                }) {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#64a20d"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(name.isEmpty || height.isZero || weight.isZero || !saved_users.isEmpty || age<16)
                .padding(.top, 10)
                .padding(.horizontal, 40)
                .padding(.vertical, 30)
                
                Spacer(minLength: 20)
            }
            .background(Color.white)
            .navigationDestination(isPresented: $navigateToMindfulness) {
                MindfulnessView()
            }
        }
    }
    
    func saveUserAndCalculate(context: ModelContext) {
        let age = Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year ?? 0
        let newUser = User(name: name, age: age, height: height, weight: weight, sesso: sesso, lpa: lpa, caloricRange: .range1, ageRange: .age_16_20, adequateIntake: [.calcium : 0.0, .iron : 0.0, .vitaminC : 0.0], BMR: 0.0, MHR: 0, carbTarget: 0.0, proteinTarget: 0.0, fatTarget: 0.0)
        context.insert(newUser)
        print("Saved: \(newUser)")
        try! context.save()
        
        ReferenceValuesFunction(context: context)
        print("Reference values calculated: \(newUser)")
        print("Saved: \(newUser.MHR)")
        navigateToMindfulnessCounterView = true
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}

#Preview {
    NewUserView()
}
