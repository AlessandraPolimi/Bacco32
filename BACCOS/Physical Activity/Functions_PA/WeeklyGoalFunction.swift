//
//  WeeklyGoalFunc.swift
//  BACCO
//
//  Created by GIF on 13/05/24.
//

import Foundation
import SwiftData

func WeeklyGoal (lpa: LivelloPA) -> Double{
    
    var wg = 0.0
    
    //let dbUser = try! context.fetch(FetchDescriptor<Personal>())
    
    //for user in dbUser{
        switch lpa{
        case .HighPA: wg = 300.0
        case .ModeratePA: wg = 250.0
        case .LowPA: wg = 200.0
        case .Sedentary: wg = 150.0
        case .ExtraPA: wg = 350.0
        }
   // }
    
    return wg
    
}
