//
//  UserRangeFunction.swift
//  BACCO
//
//  Created by GIF on 10/05/24.
//

import Foundation
import SwiftData
func calculateUserRange(valuesSDNN: [Double], valuesRMSSD: [Double]) -> (Double, Double, Double, Double, Double, Double) {
    // Per SDNN
    let sortedValuesSDNN = valuesSDNN.sorted()
    let countSDNN = sortedValuesSDNN.count
    
    // Calcolo della mediana SDNN
    let medianSDNN: Double
    if countSDNN % 2 == 0 {
        medianSDNN = (sortedValuesSDNN[countSDNN / 2 - 1] + sortedValuesSDNN[countSDNN / 2]) / 2
    } else {
        medianSDNN = sortedValuesSDNN[countSDNN / 2]
    }
    
    // Calcolo del 15esimo percentile SDNN
    let percentile15IndexSDNN = Int(0.15 * Double(countSDNN - 1))
    let percentile15SDNN = sortedValuesSDNN[percentile15IndexSDNN]
    
    // Calcolo dell'85esimo percentile SDNN
    let percentile85IndexSDNN = Int(0.85 * Double(countSDNN - 1))
    let percentile85SDNN = sortedValuesSDNN[percentile85IndexSDNN]
    
    // Per RMSSD
    let sortedValuesRMSSD = valuesRMSSD.sorted()
    let countRMSSD = sortedValuesRMSSD.count
    
    // Calcolo della mediana RMSSD
    let medianRMSSD: Double
    if countRMSSD % 2 == 0 {
        medianRMSSD = (sortedValuesRMSSD[countRMSSD / 2 - 1] + sortedValuesRMSSD[countRMSSD / 2]) / 2
    } else {
        medianRMSSD = sortedValuesRMSSD[countRMSSD / 2]
    }
    
    // Calcolo del 15esimo percentile RMSSD
    let percentile15IndexRMSSD = Int(0.15 * Double(countRMSSD - 1))
    let percentile15RMSSD = sortedValuesRMSSD[percentile15IndexRMSSD]
    
    // Calcolo dell'85esimo percentile RMSSD
    let percentile85IndexRMSSD = Int(0.85 * Double(countRMSSD - 1))
    let percentile85RMSSD = sortedValuesRMSSD[percentile85IndexRMSSD]
    
    return (medianSDNN, percentile15SDNN, percentile85SDNN, medianRMSSD, percentile15RMSSD, percentile85RMSSD)
}


/*
func compareLastItemWithPercentiles(context: ModelContext, p35: Double, p65: Double, pp35: Double, pp65: Double) -> (sdnnResult: ComparisonResult, rmssdResult: ComparisonResult)? {
    let dbHRVMetrics = try! context.fetch(FetchDescriptor<HRVMetrics>())
    
    // Confronto i valori sdnn e rmssd dell'ultimo item con i percentili
    let sdnnComparison: ComparisonResult
    let rmssdComparison: ComparisonResult
    
    if let lastSDNN = dbHRVMetrics.last?.sdnn {
        if lastSDNN < p35 {
            sdnnComparison = .below35thPercentile
        } else if lastSDNN > p65 {
            sdnnComparison = .above65thPercentile
        } else {
            sdnnComparison = .withinRange
        }
    } else {
        sdnnComparison = .noValue
    }
    
    if let lastRMSSD = dbHRVMetrics.last?.rmssd {
        if lastRMSSD < pp35 {
            rmssdComparison = .below35thPercentile
        } else if lastRMSSD > pp65 {
            rmssdComparison = .above65thPercentile
        } else {
            rmssdComparison = .withinRange
        }
    } else {
        rmssdComparison = .noValue
    }
    
    return (sdnnResult: sdnnComparison, rmssdResult: rmssdComparison)
}*/


func compareLastItemWithPercentiles(context: ModelContext, p35: Double, p65: Double, pp35: Double, pp65: Double, sdnnValue: Double, rmssdValue: Double) -> (sdnnResult: ComparisonResult, rmssdResult: ComparisonResult)? {
    // Crea una richiesta di fetch per HRVMetrics ordinata per data decrescente
    /*let fetchRequest = FetchDescriptor<HRVMetrics>(
        sortBy: [SortDescriptor(\.date, order: .reverse)]
    )*/
        
        // Confronto i valori sdnn e rmssd dell'elemento più recente con i percentili
        let sdnnComparison: ComparisonResult
        let rmssdComparison: ComparisonResult
        
        if sdnnValue < p35 {
            sdnnComparison = .below35thPercentile
        } else if sdnnValue > p65 {
            sdnnComparison = .above65thPercentile
        } else {
            sdnnComparison = .withinRange
        }
        
        if rmssdValue < pp35 {
            rmssdComparison = .below35thPercentile
        } else if rmssdValue > pp65 {
            rmssdComparison = .above65thPercentile
        } else {
            rmssdComparison = .withinRange
        }
        
        // Log dei risultati
        print("L'elemento confrontato - RMSSD: \(rmssdValue), SDNN: \(sdnnValue)")
        print("SDNN Comparison: \(sdnnComparison)")
        print("RMSSD Comparison: \(rmssdComparison)")
        
        return (sdnnResult: sdnnComparison, rmssdResult: rmssdComparison)
        
}








// Enum per rappresentare i risultati del confronto
enum ComparisonResult {
    case below35thPercentile
    case above65thPercentile
    case withinRange
    case noValue // Aggiunto un nuovo caso per indicare l'assenza di valore
    
    }
