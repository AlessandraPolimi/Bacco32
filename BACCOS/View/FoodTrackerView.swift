//
//  FoodTrackerView_NEW.swift
//  BACCO
//
//  Created by GIF on 16/05/24.
//

import Foundation
import SwiftUI
import SwiftData

struct FoodTrackerView: View {
    @Environment(\.modelContext) var context
    @State private var isShowingItemSheet = false
    @Query var addedFoods: [AddedFood] = []
    @State private var foodToEdit: AddedFood?
    
    var body: some View {
        NavigationStack {
            VStack {
                if addedFoods.isEmpty || !addedFoods.contains(where: { calendar.isDate($0.date, equalTo: .now, toGranularity: .day) }) {
                    VStack {
                        Spacer()
                            .frame(height: 150)
                        
                        Image(systemName: "fork.knife.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(Color(hex: "#64a20d"))
                            .padding(.bottom, 20)
                        
                        Text("No meals added for today")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.bottom, 5)
                        
                        Text("Start adding meals to keep track of your nutrition.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 40)
                        
                        Button(action: {
                            isShowingItemSheet = true
                        }) {
                            Text("Add Meal")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(hex: "#64a20d").opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 40)
                        .padding(.top, 20)
                        
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(addedFoods) { addedFood in
                            if calendar.isDate(addedFood.date, equalTo: .now, toGranularity: .day) {
                                FoodCell(addedFood: addedFood)
                                    .onTapGesture {
                                        foodToEdit = addedFood
                                    }
                            }
                        }
                        .onDelete(perform: { indexSet in
                            for index in indexSet {
                                context.delete(addedFoods[index])
                            }
                        })
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("Added Meals")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isShowingItemSheet) {
                AddFoodSheet()
            }
            .sheet(item: $foodToEdit) { addedFood in
                UpdateFoodSheet(addedFood: addedFood)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingItemSheet = true
                    }) {
                        Label("Add Meal", systemImage: "plus")
                            .foregroundColor(Color(hex: "#64a20d"))
                    }
                }
            }
        }
    }
}

#Preview {
    FoodTrackerView()
}

struct FoodCell: View {
    let addedFood: AddedFood

    var body: some View {
        HStack {
            Text(addedFood.name)
                .foregroundColor(Color(hex: "#64a20d"))
            Spacer()
            Text("\(addedFood.grams, specifier: "%.1f") grams")
                .foregroundColor(.gray)
            Spacer()
            Text(addedFood.date, format: .dateTime.month(.abbreviated).day())
                .frame(width: 70, alignment: .leading)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(hex: "#64a20d").opacity(0.1))
        .cornerRadius(10)
    }
}

struct AddFoodSheet: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    @Query var foodItems: [FoodItem] = []
    @State private var searchTerm = ""
    @State private var name: String = ""
    @State private var gramsText: String = ""
    @State private var date: Date = .now
    @State private var showingFoodList = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Aggiungi un'immagine di intestazione
                Image(systemName: "fork.knife.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(Color(hex: "#64a20d"))
                    .padding(.top, 30)
                
                // Titolo
                Text("Add your meal")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Form {
                    TextField("Insert food", text: $name)
                        .onTapGesture {
                            self.showingFoodList = true
                        }
                    TextField("Insert amount in grams", text: $gramsText)
                        .keyboardType(.decimalPad)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Bottoni
                HStack {
                    Button(action: { dismiss() }) {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        if let grams = Double(gramsText) {
                            let addedFood = AddedFood(name: name, grams: grams, date: date)
                            context.insert(addedFood)
                            dismiss()
                        }
                    }) {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "#64a20d"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(gramsText.isEmpty || name.isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .sheet(isPresented: $showingFoodList) {
                FoodListView(foodItems: Array(foodItems), selectedName: $name, showingFoodList: $showingFoodList)
            }
        }
    }
}

#Preview {
    AddFoodSheet()
}


struct FoodListView: View {
    var foodItems: [FoodItem]
    @State private var searchTerm: String = ""
    @Binding var selectedName: String
    @Binding var showingFoodList: Bool

    var filteredFoodItems: [FoodItem] {
        guard !searchTerm.isEmpty else { return foodItems }
        return foodItems.filter { $0.name.localizedCaseInsensitiveContains(searchTerm) }
    }

    var body: some View {
        NavigationStack {
            List {
                TextField("Search", text: $searchTerm)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                ForEach(filteredFoodItems, id: \.self) { filteredFoodItem in
                    Text(filteredFoodItem.name)
                        .onTapGesture {
                            self.selectedName = filteredFoodItem.name
                            self.showingFoodList = false
                        }
                }
            }
            .navigationTitle("Select Food Item")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        self.showingFoodList = false
                    }
                }
            }
        }
    }
}

struct UpdateFoodSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var addedFood: AddedFood
    @State private var showingFoodList = false
    @Query var foodItems: [FoodItem] = []
    @State private var searchTerm = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Insert Food", text: $addedFood.name)
                    .onTapGesture {
                        self.showingFoodList = true
                    }
                TextField("Insert amount in grams", value: $addedFood.grams, format: .number)
                    .keyboardType(.decimalPad)
                DatePicker("Date", selection: $addedFood.date, displayedComponents: .date)
            }
            .navigationTitle("Update Meal")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingFoodList) {
                FoodListView(foodItems: Array(foodItems), selectedName: $addedFood.name, showingFoodList: $showingFoodList)
            }
        }
    }
}
