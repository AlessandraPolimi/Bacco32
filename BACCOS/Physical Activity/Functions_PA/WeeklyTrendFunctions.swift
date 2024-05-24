//
//  WeeklyTrendFunctions.swift
//  BACCO
//
//  Created by GIF on 13/05/24.
//

import Foundation
import SwiftData

func DailyIndexPACalculation (context: ModelContext, weeklygoal: Double) -> Double{
    
    var PA_Index = 0.0
    var AccumulatedPoints = 0.0
    let dbPunteggi = try! context.fetch(FetchDescriptor<Punteggio>())
    let dailyexpectedpoints = calcoloDEP(obiettivoSettimanale: weeklygoal)

    //let oggi = Date()
    ////let ieri = Calendar.current.date(byAdding: .day, value: -1, to: oggi)!
    //let dateFormatter = DateFormatter()
    //dateFormatter.dateFormat = "yyyy-MM-dd"
    //let dataOdierna = dateFormatter.string(from: oggi)
    
    for punteggio in dbPunteggi{
        AccumulatedPoints += punteggio.punti
    }
    PA_Index = Double(AccumulatedPoints)/Double(dailyexpectedpoints)*100
    if(PA_Index>100){
        PA_Index=100.0
    }
    
    print("PA_Index: \(PA_Index)")
    return PA_Index
    
}

// calolo dei punteggio atteso del giorno prima
func calcoloDEP(obiettivoSettimanale: Double) -> Double {
    let calendar = Calendar.current
    // Ottiene la data di ieri
    let ieri = calendar.date(byAdding: .day, value: -1, to: Date())!
    // Ottiene il giorno della settimana di ieri
    let giornoSettimana = calendar.component(.weekday, from: ieri)
    // Calcola i punti giornalieri attesi per il giorno precedente
    let dailyexpectedpoints = Double(Int(obiettivoSettimanale) * giornoSettimana / 7)
    print("DEP: \(dailyexpectedpoints)")
    return dailyexpectedpoints
}


// nel caso di non allenamento sarebbe top avere punteggio = 0
func CalcoloAccumulatedPoints(context: ModelContext)->[DataPoint]{
    let dbPunteggi = try! context.fetch(FetchDescriptor<Punteggio>())
    // devo riordinare il databse
    var dbPunteggi_fake=dbPunteggi
    dbPunteggi_fake.sort { $0.data < $1.data }

    var AccumulatedPoints: [DataPoint] = []

    var somma = 0.0
        
    for punteggio in dbPunteggi_fake{
        somma += Double(punteggio.punti)
        let giorno = CalcoloGiornoSettimana(dateString: punteggio.data) ?? "Sun"
        let accumulatedPoint = DataPoint( type: "Real", day: giorno, points: somma)
        
        AccumulatedPoints.append(accumulatedPoint)
    }
    
    print(AccumulatedPoints)
    return AccumulatedPoints
    
}

func CalcoloGiornoSettimana(dateString: String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date = dateFormatter.date(from: dateString)
    
    guard let date = dateFormatter.date(from: dateString) else {
        return nil // Se la stringa non è nel formato corretto
    }
    
    let dayOfWeekFormatter = DateFormatter()
    dayOfWeekFormatter.dateFormat = "E" // "E" per il giorno della settimana abbreviato
    
    return dayOfWeekFormatter.string(from: date)
}

//funzione per svuotare il db del punteggio dopo una settimana. Svuoto il lunedì prima di ricavare i dati di domenica.
func DeletePunteggioDB(context: ModelContext) {
    do {
        let punteggi = try context.fetch(FetchDescriptor<Punteggio>())
        let calendar = Calendar.current
        let giornoDellaSettimana = calendar.component(.weekday, from: Date())
        
        if giornoDellaSettimana == 2 { // lunedì
            for punteggio in punteggi {
                context.delete(punteggio)
            }
            try context.save()
        }
    } catch {
        print("Errore durante il recupero o la cancellazione dei punteggi: \(error)")
    }
}

func Inizializzazione_Punteggio(context: ModelContext){
    let dbUser = try! context.fetch(FetchDescriptor<User>())
    let dbPunteggi = try! context.fetch(FetchDescriptor<Punteggio>())
    let user = dbUser.last!
    let weeklygoal = WeeklyGoal(lpa: user.lpa)
    var counters = MVPACounter(MPACounter: 0, VPACounter: 0)

    let punti_partenza = calcoloDEP(obiettivoSettimanale: weeklygoal)
    
    // Ottenere la data di ieri
    let calendar = Calendar.current
    let ieri = calendar.date(byAdding: .day, value: -1, to: Date())!
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let dataIeri = dateFormatter.string(from: ieri)
    
    // Verifica se esiste già un punteggio con la data di ieri
    let punteggioEsistente = dbPunteggi.first(where: { $0.data == dataIeri })
    if punteggioEsistente == nil {
        let punti_giorno = Punteggio(punti: punti_partenza, data: dataIeri, MVPACounter: counters)
        context.insert(punti_giorno)
        print("Salvato: \(punti_giorno)")
        try! context.save()
    } else {
        // Se un punteggio esiste già, non fare nulla o gestisci come preferisci
        print("Un punteggio con la stessa data esiste già.")
    }
    
}

// funzione per calcolare il punteggio atteso il giorno stesso
// func DEP_giorno_stesso(obiettivoSettimanale: Double) -> Double {
//     let calendar = Calendar.current
//     let giornoSettimana = calendar.component(.weekday, from: Date())
//     let dailyexpectedpoints = Double (Int(obiettivoSettimanale) * giornoSettimana / 7)
//     print("DEP: \(dailyexpectedpoints)")
//     return dailyexpectedpoints
// }

//salvapunteggio rispetto a giorno odierno

//func SalvaPunteggio(context: ModelContext, MHR: Int, averages: [String: Double]){
//    let dbPunteggi = try! context.fetch(FetchDescriptor<Punteggio>())
//    var counters = MVPACounter(MPACounter: 0, VPACounter: 0)
//    counters = intensityMinutes(MHR: MHR, averages: averages)
//    let oggi = Date()
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd"
//    let dataOdierna = dateFormatter.string(from: oggi)
//
//    // Verifica se esiste già un punteggio con la data odierna
//    let punteggioEsistente = dbPunteggi.first(where: { $0.data == dataOdierna })
//    if punteggioEsistente == nil {
//
//        let punti_giorno = Punteggio(punti: calcolaPunteggio(MPACounter: counters.MPACounter, VPACounter: counters.VPACounter), data: dataOdierna)
//        context.insert(punti_giorno)
//        print("Salvato: \(punti_giorno)")
//        try! context.save()
//
//    } else {
//            // Se un punteggio esiste già, non fare nulla o gestisci come preferisci
//            print("Un punteggio con la stessa data esiste già.")
//        }
//}



// funzione per calcolare il punteggio atteso il giorno stesso
// func DEP_giorno_stesso(obiettivoSettimanale: Double) -> Double {
//     let calendar = Calendar.current
//     let giornoSettimana = calendar.component(.weekday, from: Date())
//     let dailyexpectedpoints = Double (Int(obiettivoSettimanale) * giornoSettimana / 7)
//     print("DEP: \(dailyexpectedpoints)")
//     return dailyexpectedpoints
// }
