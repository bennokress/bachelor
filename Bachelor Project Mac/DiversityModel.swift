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
    func lambda(basedOn averageFitnessOfGeneration: Double, and averageDiversityOfGeneration: Double) -> Double {
        // TODO: [TUNING] Better diversity model sensitive values or no switch!
        switch self {
        case .genealogical:
            return averageFitnessOfGeneration / averageDiversityOfGeneration
        case .fitnessSharing:
            return averageFitnessOfGeneration / averageDiversityOfGeneration
        case .genomDistanceBased:
            return averageFitnessOfGeneration / averageDiversityOfGeneration
        }
    }
    
    // MARK: Generation Measurement
    func averageDiversity(for generation: Generation) -> Double {
        var combinedDiversity: Double = 0
        let individualsCount = Double(generation.deterministicIndividuals.count)
        var testCounter = 0
        for individual in generation.deterministicIndividuals {
            let individualDiversity = Double(diversityScore(of: individual, in: generation))
            if individualDiversity == 1.0 { testCounter += 1 }
            combinedDiversity += individualDiversity
        }
        let averageDiversity = combinedDiversity / individualsCount
        return averageDiversity
    }
    
    // MARK: Individual Measurement
    func diversityScore(of individual: Factory, in generation: Generation) -> Double {
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
    private func genealogyDiversity(of individual: Factory, in generation: Generation) -> Double {
        var sumOfDNADistances = 0
        for comparisonIndividual in generation.deterministicIndividuals {
            guard let bitstringDistance = individual.genealogyDNA.distance(to: comparisonIndividual.genealogyDNA) else {
                fatalError("Lengths of the genealogyDNAs don't match!")
            }
            sumOfDNADistances += bitstringDistance
        }
        let averageDistance = Double(sumOfDNADistances) / Double(generation.deterministicIndividuals.count)
        return averageDistance
    }
    
    /// Measuring the pairwise distance of all workstations of the individual in its generation.
    private func genomDistanceBasedDiversity(of individual: Factory, in generation: Generation) -> Double {
        var sumOfWorkstationDistances = 0
        for comparisonIndividual in generation.deterministicIndividuals {
            for (i, workstation) in individual.sortedWorkstations.enumerated() {
                let comparisonWorkstation = comparisonIndividual.sortedWorkstations[i]
                sumOfWorkstationDistances += workstation.position.distance(to: comparisonWorkstation.position)
            }
        }
        let averageSumOfDistances = Double(sumOfWorkstationDistances) / Double(generation.deterministicIndividuals.count)
        let averageDistance = averageSumOfDistances / Double(individual.workstations.count)
        return averageDistance
    }
    
    /// Measuring the diversity in respect to the individual with the best fitness in the generation.
    private func fitnessSharingDiversity(of individual: Factory, in generation: Generation) -> Double {
        guard let comparisonIndividual = generation.sortedByFitness.first else { fatalError("Could not find best individual in generation!") }
        if individual == comparisonIndividual {
            return 1.0 // fitness of the best individual will not be modified by the diversity score
        } else {
            var sumOfWorkstationDistances = 0
            for (i, workstation) in individual.sortedWorkstations.enumerated() {
                let comparisonWorkstation = comparisonIndividual.sortedWorkstations[i]
                sumOfWorkstationDistances += workstation.position.distance(to: comparisonWorkstation.position)
            }
            let averageDistance = Double(sumOfWorkstationDistances) / Double(individual.workstations.count)
            // TODO: [TUNING] Threshold based on factory layout, but how?
            let threshold = Double(individual.layout.size) / 100
            return (averageDistance > threshold) ? 1.0 : (averageDistance / threshold)
        }
    }
    
}
