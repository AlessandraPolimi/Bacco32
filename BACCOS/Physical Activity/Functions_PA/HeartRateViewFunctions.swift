//
//  HeartRateViewFunctions.swift
//  BACCO
//
//  Created by GIF on 13/05/24.
//
import Foundation
import SwiftUI
import SwiftData

// calculateAverageHeartRates(): Calcola la media dei battiti cardiaci per ogni minuto e aggiorna il dizionario averages
func calculateAverageHeartRates(groupedHeartRates: [String: [HeartRateData]]) -> [String: Double] {
    var averages: [String: Double] = [:]
        for (minute, heartRates) in groupedHeartRates {
            let total = heartRates.reduce(0.0) { $0 + $1.value }
            let average = total / Double(heartRates.count)
            averages[minute] = average
        }
    print("averages: \(averages)")
    return averages
}

// Definisce un tipo di dato per i battiti cardiaci. Identifiable permette a SwiftUI di identificare univocamente le istanze per ottimizzare l'aggiornamento dell'interfaccia.


// groupHeartRatesByMinute: Raggruppa i dati dei battiti cardiaci per minuto, utilizzando un DateFormatter per formattare le date.
func groupHeartRatesByMinute(data: [HeartRateData]) -> [String: [HeartRateData]] {
    var groupedData: [String: [HeartRateData]] = [:]
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    
    for heartRate in data {
        let minuteKey = dateFormatter.string(from: heartRate.date)
        groupedData[minuteKey, default: []].append(heartRate)
    }
    
    return groupedData
}

func intensityMinutes(MHR: Int, averages: [String: Double]) -> MVPACounter {
    var mvpaCounter = MVPACounter(MPACounter: 0, VPACounter: 0)
    let Mmin = MHR * 63 / 100
    let Mmax = MHR * 76 / 100
    let Vmax = MHR * 93 / 100
    
    for (_, average) in averages {
        if (average > Double(Mmin) && average <= Double(Mmax)) {
            mvpaCounter.MPACounter += 1
        } else if (average > Double(Mmax) && average <= Double(Vmax)) {
            mvpaCounter.VPACounter += 1
        }
    }
    
    return mvpaCounter
}

func calcolaPunteggio(MPACounter: Int, VPACounter: Int) -> Double {
    print("MPACounter:\(MPACounter)")
    print("VPACounter:\(VPACounter)")
    return Double(MPACounter + VPACounter * 2)
    
}

func SalvaPunteggio(context: ModelContext, MHR: Int, averages: [String: Double]) {
    let dbPunteggi = try! context.fetch(FetchDescriptor<Punteggio>())
    var counters = MVPACounter(MPACounter: 0, VPACounter: 0)
    counters = intensityMinutes(MHR: MHR, averages: averages)
    
    // Ottenere la data di ieri
    let calendar = Calendar.current
    let ieri = calendar.date(byAdding: .day, value: -1, to: Date())!
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let dataIeri = dateFormatter.string(from: ieri)

    // Verifica se esiste già un punteggio con la data di ieri
    let punteggioEsistente = dbPunteggi.first(where: { $0.data == dataIeri })
    if punteggioEsistente == nil {
        let punti_giorno = Punteggio(punti: calcolaPunteggio(MPACounter: counters.MPACounter, VPACounter: counters.VPACounter), data: dataIeri, MVPACounter: counters)
        context.insert(punti_giorno)
        print("Punti del giorno con allenamento: \(punti_giorno)")
        try! context.save()
    } else {
        // Se un punteggio esiste già, non fare nulla o gestisci come preferisci
        print("Un punteggio con la stessa data esiste già.")
    }
}


func SalvaPunteggio_SenzaAllenamento(context: ModelContext){
    let dbPunteggi = try! context.fetch(FetchDescriptor<Punteggio>())
    let counters = MVPACounter(MPACounter: 0, VPACounter: 0)

    
    // Ottenere la data di ieri
    let calendar = Calendar.current
    let ieri = calendar.date(byAdding: .day, value: -1, to: Date())!
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let dataIeri = dateFormatter.string(from: ieri)
    
    // Verifica se esiste già un punteggio con la data di ieri
    let punteggioEsistente = dbPunteggi.first(where: { $0.data == dataIeri })
    if punteggioEsistente == nil {
        let punti_giorno = Punteggio(punti: 0, data: dataIeri, MVPACounter: counters)
        context.insert(punti_giorno)
        print("Punti del giorno senza allenamento: \(punti_giorno)")
        try! context.save()
    }
}
