//
//  ContentFunctions.swift
//  BACCO
//
//  Created by GIF on 13/05/24.
//

import Foundation
import SwiftData

func calculateMetrics(values: [Double], context: ModelContext, hr: [Double]) -> (Double, Double) {
    //let dbHRVMetrics = try! context.fetch(FetchDescriptor<HRVMetrics>())
    //let calendar = Calendar.current
    /*for HRVMetrics in dbHRVMetrics {
        if calendar.isDate(HRVMetrics.date, equalTo: .now, toGranularity: .day) {
            return // Esce se ci sono già dati per oggi
        }
    }*/
    let calendar = Calendar.current
    // Ottiene la data di ieri
    let ieri = calendar.date(byAdding: .day, value: -1, to: Date())!
    var rmssd: Double
    var sdnn: Double
    // Calcolo della media dei valori hr, controlla prima se l'array non è vuoto
    let HR = hr.isEmpty ? 0.0 : hr.reduce(0.0, +) / Double(hr.count)

    let newHRVMetrics = HRVMetrics(rmssd: 0.0, sdnn: 0.0, date: ieri)

    // Calcolo la media solo se c'è almeno un valore
    if !values.isEmpty {
        let mean = values.reduce(0, +) / Double(values.count)

        // Calcolo le differenze quadrate dalla media
        let squaredDifferences = values.map { pow($0 - mean, 2) }

        // Calcolo la media delle differenze quadrate
        let meanOfSquaredDifferences = squaredDifferences.reduce(0, +) / Double(values.count)

        // Calcolo la deviazione standard
        let nValue = sqrt(meanOfSquaredDifferences)
        
        newHRVMetrics.sdnn = nValue * exp(-0.02263 * (60 - HR))
        print("il valore che carico nuovo nel database di sdnn e': \(newHRVMetrics.sdnn)")
    }

    // Calcolo RMSSD solo se ci sono almeno due intervalli
    if values.count > 1 {
        var differences: [Double] = []
        for i in 1..<values.count {
            let difference = values[i] - values[i - 1]
            differences.append(difference)
        }

        // Elevo ogni differenza al quadrato e calcolo la somma
        let squaredSum = differences.map { $0 * $0 }.reduce(0, +)

        // Calcolo la radice quadrata della media delle somme dei quadrati
        let rValue = sqrt(squaredSum / Double(differences.count))

        newHRVMetrics.rmssd = rValue * exp(-0.03243 * (60 - HR))
        print("il valore che carico nuovo nel database di rmssd e': \(newHRVMetrics.rmssd)")
    }

    // Salvo i nuovi metadati HRV nel contesto del modello
    context.insert(newHRVMetrics)
    
    rmssd = newHRVMetrics.rmssd
    sdnn = newHRVMetrics.sdnn
    
    return (sdnn, rmssd)

}

func calculateMetrics2(values: [Double], context: ModelContext, hr: [Double]) -> (Double, Double) {
    //let dbHRVMetrics = try! context.fetch(FetchDescriptor<HRVMetrics>())
    //let calendar = Calendar.current
    /*for HRVMetrics in dbHRVMetrics {
        if calendar.isDate(HRVMetrics.date, equalTo: .now, toGranularity: .day) {
            return // Esce se ci sono già dati per oggi
        }
    }*/
    
    var rmssd: Double
    var sdnn: Double
    // Calcolo della media dei valori hr, controlla prima se l'array non è vuoto
    let HR = hr.isEmpty ? 0.0 : hr.reduce(0.0, +) / Double(hr.count)

    let newHRVMetrics = HRVMetrics(rmssd: 0.0, sdnn: 0.0, date: .now)

    // Calcolo la media solo se c'è almeno un valore
    if !values.isEmpty {
        let mean = values.reduce(0, +) / Double(values.count)

        // Calcolo le differenze quadrate dalla media
        let squaredDifferences = values.map { pow($0 - mean, 2) }

        // Calcolo la media delle differenze quadrate
        let meanOfSquaredDifferences = squaredDifferences.reduce(0, +) / Double(values.count)

        // Calcolo la deviazione standard
        let nValue = sqrt(meanOfSquaredDifferences)
        
        newHRVMetrics.sdnn = nValue * exp(-0.02263 * (60 - HR))
        print("il valore che carico nuovo nel database di sdnn e': \(newHRVMetrics.sdnn)")
    }

    // Calcolo RMSSD solo se ci sono almeno due intervalli
    if values.count > 1 {
        var differences: [Double] = []
        for i in 1..<values.count {
            let difference = values[i] - values[i - 1]
            differences.append(difference)
        }

        // Elevo ogni differenza al quadrato e calcolo la somma
        let squaredSum = differences.map { $0 * $0 }.reduce(0, +)

        // Calcolo la radice quadrata della media delle somme dei quadrati
        let rValue = sqrt(squaredSum / Double(differences.count))

        newHRVMetrics.rmssd = rValue * exp(-0.03243 * (60 - HR))
        print("il valore che carico nuovo nel database di rmssd e': \(newHRVMetrics.rmssd)")
    }

    // Salvo i nuovi metadati HRV nel contesto del modello
    context.insert(newHRVMetrics)
    
    rmssd = newHRVMetrics.rmssd
    sdnn = newHRVMetrics.sdnn
    
    return (sdnn, rmssd)

}


func performHRVcalculation(context:  ModelContext, sdnnValue: Double, rmssdValue: Double) -> (Double, Double){
    let (sdnnarray, rmssdarray) = getLast21Metrics(context: context)
    let (medianasdnn, p15sdnn, p85sdnn, medianarmssd, p15rmssd, p85rmssd) = calculateUserRange(valuesSDNN: sdnnarray, valuesRMSSD: rmssdarray)
    let comparisonResults = compareLastItemWithPercentiles(context: context, p35: p15sdnn, p65: p85sdnn, pp35: p15rmssd, pp65: p85rmssd, sdnnValue: sdnnValue, rmssdValue: rmssdValue)
    let (sdnnScore, rmssdScore) = calculateScores(result: comparisonResults!.sdnnResult, m: medianasdnn, p35: p15sdnn, p65: p85sdnn, resultt: comparisonResults!.rmssdResult, mm: medianarmssd, pp35: p15rmssd, pp65: p85rmssd, context: context, sdnnValue: sdnnValue, rmssdValue: rmssdValue)
    return (sdnnScore, rmssdScore)
}

func calculateScores(result: ComparisonResult, m: Double, p35: Double, p65: Double, resultt: ComparisonResult, mm: Double, pp35: Double, pp65: Double, context: ModelContext, sdnnValue: Double, rmssdValue: Double) -> (Double, Double) {
    let dbUser = try! context.fetch(FetchDescriptor<User>())
    guard let user = dbUser.last else { return (0.0, 0.0) }
    
    let minRMSSD = user.physiologicalRange[.rmssd_physiological]?.min ?? 0.0
    let maxRMSSD = user.physiologicalRange[.rmssd_physiological]?.max ?? 350.0
    let minSDNN = user.physiologicalRange[.sdnn_physiological]?.min ?? 0.0
    let maxSDNN = user.physiologicalRange[.sdnn_physiological]?.max ?? 350.0
    
    let sdnn = sdnnValue
    let rmssd = rmssdValue
    
    print("Il valore che realmente valuto SDNN: \(sdnn)")
    print("Il valore che realmente valuto RMSSD: \(rmssd)")
    
    var scoreSDNN: Double = 0.0
    var scoreRMSSD: Double = 0.0
    
    // Calcolo punteggio SDNN
    scoreSDNN = calculateIndividualScore(value: sdnn, minValue: minSDNN, maxValue: maxSDNN, median: m, p35: p35, p65: p65, result: result)
    
    // Calcolo punteggio RMSSD
    scoreRMSSD = calculateIndividualScore(value: rmssd, minValue: minRMSSD, maxValue: maxRMSSD, median: mm, p35: pp35, p65: pp65, result: resultt)
    
    print("Punteggio SDNN: \(scoreSDNN)")
    print("Punteggio RMSSD: \(scoreRMSSD)")
    
    return (scoreSDNN, scoreRMSSD)
}

private func calculateIndividualScore(value: Double, minValue: Double, maxValue: Double, median: Double, p35: Double, p65: Double, result: ComparisonResult) -> Double {
    var score: Double = 0.0

    print("Calcolo punteggio per value: \(value), minValue: \(minValue), maxValue: \(maxValue), median: \(median), p35: \(p35), p65: \(p65), result: \(result)")

    // Controlli preliminari
    guard minValue < maxValue else {
        print("Errore: minValue (\(minValue)) non può essere maggiore di maxValue (\(maxValue))")
        return 0.0
    }
    
    guard p35 < median && median < p65 else {
        print("Errore: p35 (\(p35)), median (\(median)), e p65 (\(p65)) non rispettano l'ordine corretto")
        return 0.0
    }
    
    switch result {
    case .below35thPercentile:
        if value > minValue {
            score = 50.0 + ((value - minValue) / (p35 - minValue)) * 25.0
        } else {
            score = (value / minValue) * 50.0
        }
        
    case .above65thPercentile:
        if value < maxValue {
            score = 50.0 + ((maxValue - value) / (maxValue - p65)) * 25.0
        } else {
            score = ((350.0 - value) / (350.0 - maxValue)) * 50.0
        }
        
    case .withinRange:
        if value < median {
            score = 75.0 + ((value - p35) / (median - p35)) * 25.0
        } else {
            score = 75.0 + ((p65 - value) / (p65 - median)) * 25.0
        }
        
    case .noValue:
        print("Errore nel calcolo del punteggio")
    }
    
    print("Punteggio calcolato: \(score)")
    return score
}




/*
func getLast21Metrics(context: ModelContext) -> ([Double], [Double]) {
        let dbHRVMetrics = try! context.fetch(FetchDescriptor<HRVMetrics>())
        
        // Assicuriamo che ci siano almeno 5 metriche disponibili
        guard dbHRVMetrics.count >= 5 else {
            // Se non ci sono almeno 5 elementi, ritorna array con un solo 0 in ciascuno
            return ([0.0], [0.0])
        }
        
        // Prendi fino a 21 metriche a partire dalla seconda
        let metricsInRange = Array(dbHRVMetrics.dropFirst(1).prefix(21))
        
        var sdnnArray = [Double]()
        var rmssdArray = [Double]()
        
        for metric in metricsInRange {
            print("il valore in metric sdnn e'\(metric.sdnn)")
            print("il valore in metric rmssd e' \(metric.rmssd)")
            sdnnArray.append(metric.sdnn)
            rmssdArray.append(metric.rmssd)
        }
        return (sdnnArray, rmssdArray)
}
*/


func getLast21Metrics(context: ModelContext) -> ([Double], [Double]) {
    // Crea una richiesta di fetch per HRVMetrics
    let fetchRequest = FetchDescriptor<HRVMetrics>(
        sortBy: [SortDescriptor(\.date, order: .reverse)]
    )
    
    do {
        // Esegui la richiesta di fetch
        let dbHRVMetrics = try context.fetch(fetchRequest)
        
        // Assicuriamo che ci siano almeno 2 metriche disponibili
        guard dbHRVMetrics.count >= 5 else {
            // Se non ci sono almeno 5 elementi, ritorna array con un solo 0 in ciascuno
            return ([0.0], [0.0])
        }
        
        // Prendi fino a 21 metriche escludendo la più recente
        let metricsInRange = Array(dbHRVMetrics.dropLast(1).prefix(21))
        
        var sdnnArray = [Double]()
        var rmssdArray = [Double]()
        
        for metric in metricsInRange {
            print("il valore in metric sdnn e' \(metric.sdnn)")
            print("il valore in metric rmssd e' \(metric.rmssd)")
            sdnnArray.append(metric.sdnn)
            rmssdArray.append(metric.rmssd)
        }
        return (sdnnArray, rmssdArray)
        
    } catch {
        print("Failed to fetch HRVMetrics: \(error)")
        return ([0.0], [0.0])
    }
}
