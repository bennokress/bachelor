//
//  DiversityModel.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 26.08.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

enum DiversityModel: String, Encodable {
    case genealogical
    case fitnessSharing
    case genomDistanceBased
    
    /// Factor in calculating the diversity-influenced fitness f'.
    var lambda: Double {
        // TODO: Set values
        switch self {
        case .genealogical:
            return 0.0
        case .fitnessSharing:
            return 0.0
        case .genomDistanceBased:
            return 0.0
        }
    }
    
    // MARK: Generation Measurement
    func averageDiversity(for generation: Generation) -> Double {
        var combinedDiversity: Double = 0
        let generationSize = Double(generation.size)
//        var csvStats = ""
        for individual in generation.individuals {
            let individualDiversity = Double(diversityScore(of: individual, in: generation))
            combinedDiversity += individualDiversity
//            csvStats += "\(individualDiversity);"
        }
        let averageDiversity = combinedDiversity / generationSize
//        csvStats += "\(averageDiversity);"
//        print(csvStats)
        return averageDiversity
    }
    
    // MARK: Individual Measurement
    func diversityScore(of individual: Factory, in generation: Generation) -> Int {
        switch self {
        case .genealogical:
            return genealogyDiversity(of: individual, in: generation)
        case .fitnessSharing:
            return fitnessSharingDiversity(of: individual, in: generation)
        case .genomDistanceBased:
            return genomDistanceBasedDiversity(of: individual, in: generation)
        }
    }
    
    // Measuring the distance of an individuals genealogyDNA to all other DNAs of its generation.
    private func genealogyDiversity(of individual: Factory, in generation: Generation) -> Int {
        var sumOfDNADistances = 0
        for comparisonIndividual in generation.individuals {
            guard let bitstringDistance = individual.genealogyDNA.distance(to: comparisonIndividual.genealogyDNA) else {
                fatalError("Lengths of the genealogyDNAs don't match!")
            }
            sumOfDNADistances += bitstringDistance
        }
//        print("\(sumOfDNADistances);\(fitnessSharingDiversity(of: individual, in: generation));")
//        print("Genealogy: \(sumOfDNADistances)\t\t Fitness Sharing: \(fitnessSharingDiversity(of: individual, in: generation))")
        return sumOfDNADistances
    }
    
    /// Measuring the pairwise distance of all workstations of the individual in its generation.
    private func fitnessSharingDiversity(of individual: Factory, in generation: Generation) -> Int {
        var sumOfWorkstationDistances = 0
        for comparisonIndividual in generation.individuals {
            for (i, workstation) in individual.sortedWorkstations.enumerated() {
                let comparisonWorkstation = comparisonIndividual.sortedWorkstations[i]
                sumOfWorkstationDistances += workstation.position.distance(to: comparisonWorkstation.position)
            }
        }
        return sumOfWorkstationDistances
    }
    
    private func genomDistanceBasedDiversity(of individual: Factory, in generation: Generation) -> Int {
        // TODO: Implement this
        return 0
    }
    
}
