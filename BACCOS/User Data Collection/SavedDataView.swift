//
//  SavedDataView.swift
//  BACCO
//
//  Created by GIF on 10/05/24.
//


// SAVED DATA VIEW
import Foundation
import SwiftData
import SwiftUI

struct SavedDataView: View {
    var user: User
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
    
    @State private var name: String = ""
    @State private var birthDate: Date = Date()
    @State private var height: Double = 0.0
    @State private var weight: Double = 0.0
    @State private var sesso = Sesso.Maschio
    @State private var lpa = LivelloPA.Sedentary
    
    @State private var showingDatePicker = false
    @State private var showingPALInfo = false // Variabile di stato per l'alert

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                Spacer(minLength: 10) // Aumenta lo spazio superiore
                
                // Header con icona e titolo
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(Color(hex: "#64a20d"))
                
                Text("Your Profile")
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
                            String(self.height)
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
                            String(self.weight)
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
                        Picker("Physical Activity Level", selection: $lpa) {
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
                                message: Text("PAL (Physical Activity Level) is a measure that quantifies an individual's overall level of physical activity.\nExtraPAL: twice a day (hard work)\nHighPAL: 6-7 times a week\nModeratePAL: 3-5 times a week\nLowPAL: 1-3 times a week\nSedentary: very low"),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                        .padding(.leading, 8) // Aggiungi un po' di spazio tra il picker e il pulsante
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                .padding(.horizontal, 20)
                
                // Pulsante Update separato
                Button(action: {
                    let age = Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year ?? 0
                    user.name = name
                    user.sesso = sesso
                    user.age = age
                    user.lpa = lpa
                    user.height = height
                    user.weight = weight
                    
                    ReferenceValuesFunction(context: context)
                    dismiss()
                }) {
                    Text("Update")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#64a20d"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!changed)
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 60) // Aggiungi spazio inferiore
                
                Spacer(minLength: 20)
            }
            .background(Color.white) // Assicurati che lo sfondo sia bianco
            .onAppear {
                name = user.name
                sesso = user.sesso
                birthDate = Calendar.current.date(byAdding: .year, value: -user.age, to: Date()) ?? Date()
                lpa = user.lpa
                height = user.height
                weight = user.weight
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var changed: Bool {
        sesso != user.sesso
        || name != user.name
        || birthDate != Calendar.current.date(byAdding: .year, value: -user.age, to: Date())
        || lpa != user.lpa
        || height != user.height
        || weight != user.weight
    }
}

#Preview {
    SavedDataView(user: User(name: "Sample", age: 25, height: 170, weight: 70, sesso: .Maschio, lpa: .Sedentary, caloricRange: .range1, ageRange: .age_16_20, adequateIntake: [.calcium: 0.0, .iron: 0.0, .vitaminC: 0.0], BMR: 0.0, MHR: 0, carbTarget: 0.0, proteinTarget: 0.0, fatTarget: 0.0))
}
