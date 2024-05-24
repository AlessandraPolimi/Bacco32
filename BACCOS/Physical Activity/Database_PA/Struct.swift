//
//  Struct.swift
//  BACCO
//
//  Created by GIF on 13/05/24.
//
import SwiftData
import Foundation

struct HeartRateData: Identifiable {
    let id = UUID()
    let value: Double
    let date: Date
}

@Model
class Punteggio{
    
    var punti: Double
    var data: String
    var MVPACounter: MVPACounter
    
    init(punti: Double, data: String, MVPACounter: MVPACounter) {
        self.punti = punti
        self.data = data
        self.MVPACounter = MVPACounter
    }
    
}

struct MVPACounter: Codable, Hashable {
    var MPACounter: Int
    var VPACounter: Int
}

struct DataPoint: Identifiable, Hashable {
    let id = UUID().uuidString // Identificatore unico per ogni punto dati (necessario per ForEach)
    var type: String
    var day: String // Giorno della settimana
    var points: Double // Punteggio raggiunto in quel giorno

    init(type: String, day: String, points: Double) {
        self.type = type
        self.day = day
        self.points = points
    }
}
