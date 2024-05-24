//
//  WelcomeView.swift
//  BACCO
//
//  Created by GIF on 15/05/24.
//

import Foundation
import SwiftUI
import SwiftData

struct WelcomeView: View {
    
    @Environment(\.modelContext) var context
    @Query var FoodItem: [FoodItem]
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                    .frame(height: 120)
                
                // LOGO
                Image("Image")
                    .resizable()
                    .scaledToFit()
                    .padding()
                
                Spacer()
                    .frame(height: 30)
                
                // Welcome Text
                Text("Hey, Welcome!")
                    .font(.title)
                    .fontWeight(.bold)
                    .font(.system(size: 28))
                
                Text("We will guide you through your health consciousness journey.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .font(.system(size: 18))
                
                
                VStack(spacing: 10) {
                    NavigationLink(destination: WelcomeView2().navigationBarBackButtonHidden(true)) {
                        Text("Get Started")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "#62a230"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 30)
                
                Spacer()
                    .frame(height: 60) //
            }
            .onAppear(perform: {
                if FoodItem.isEmpty {
                    populateFoodDatabaseEuropean(context: context)
                    // populateProve(context: context)
                }
            })
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
        }
        
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8 * 4) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}



struct WelcomeView2: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer(minLength: 50)
                // LOGO
                Image("Image")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.top, 20)
                    .frame(width: 170, height: 170)
                
                Spacer()
                    .frame(height: 10)
                
                // BACCO INDEX
                IndexRowView(
                    icon: "trophy",
                    iconColor: Color(hex: "#62a230"),
                    title: "THE BACCO INDEX",
                    subtitle: "A daily index of your health status \nthat considers various aspects of \nyour well-being"
                )
                
                // Arrow pointing down
                Image(systemName: "arrow.down")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color(hex: "#62a230"))
                    .padding(.bottom, 20)
                    .padding(.top, 20)
                
                // NUTRITION INDEX
                IndexRowView(
                    icon: "fork.knife",
                    iconColor: Color(hex: "#62a230"),
                    title: "NUTRITION",
                    subtitle: "Evaluation of your dietary habits"
                )
                
                // PHYSICAL ACTIVITY INDEX
                IndexRowView(
                    icon: "figure.walk",
                    iconColor: Color(hex: "#62a230"),
                    title: "PHYSICAL ACTIVITY",
                    subtitle: "Tracking of your physical activity"
                )
                
                // MENTAL HEALTH INDEX
                IndexRowView(
                    icon: "brain.head.profile",
                    iconColor: Color(hex: "#62a230"),
                    title: "MENTAL HEALTH",
                    subtitle: "Assessment of your mental well-being"
                )
                .padding(.bottom, 20)
                
                VStack {
                    NavigationLink(destination: NewUserView().navigationBarBackButtonHidden(true)) {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "#62a230"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 30)
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    WelcomeView2()
}

struct IndexRowView: View {
    var icon: String
    var iconColor: Color
    var title: String
    var subtitle: String
    var backgroundColor: Color = Color(hex: "#e6f5d0")
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(iconColor)
                .padding()
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.vertical, 10)
            
            Spacer()
        }
        .background(backgroundColor)
        .cornerRadius(10)
        .padding(.horizontal, 20)
        .padding(.vertical, 5)
        .frame(maxWidth: .infinity)
    }
}

