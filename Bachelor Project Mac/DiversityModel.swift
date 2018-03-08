//
//  DiversityModel.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 26.08.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

enum DiversityModel: String {
    
    case genealogical
    case fitnessSharing
    case genomeDistanceBased
    
    // MARK: - ⚙️ Computed Properties
    
    /// Average fitness observed at the end of all test simulations
    var observationBasedAverageFitnessOfGeneration: Double {
        return 157.00
    }
    
    /// Average diversity observed at the end of all test simulations
    var observationBasedAverageDiversityOfGeneration: Double {
        switch self {
        case .genealogical:
            return 2.51934118
        case .fitnessSharing:
            return 0.06017415
        case .genomeDistanceBased:
            return 0.61034056
        }
    }
    
    /// Factor in calculating the diversity-influenced adapted fitness f'
    var lambda: Double {
        return observationBasedAverageFitnessOfGeneration / (1 / observationBasedAverageDiversityOfGeneration)
    }
    
    // MARK: - 📗 Functions
    
    /// Returns the average diversity measured in the given generation. Uses the diversity model specified in settings, if none is provided at call site
    func averageDiversity(for generation: Generation, with diversityModel: DiversityModel? = nil) -> Double {
        var combinedDiversity: Double = 0
        let individualsCount = Double(generation.deterministicIndividuals.count)
        var testCounter = 0
        for individual in generation.deterministicIndividuals {
            let individualDiversity = Double(diversityScore(of: individual, in: generation, with: diversityModel) ?? lambda)
            if individualDiversity == 1.0 { testCounter += 1 }
            combinedDiversity += individualDiversity
        }
        let averageDiversity = combinedDiversity / individualsCount
        return averageDiversity
    }
    
    /// Returns an individual's measured diversity in the given generation. Uses the diversity model specified in settings, if none is provided at call site
    func diversityScore(of individual: Factory, in generation: Generation, with diversityModel: DiversityModel? = nil) -> Double? {
        let neededDiversityModel = diversityModel ?? self // This normally calls self. Only exception: Statistics need all diversity scores!
        switch neededDiversityModel {
        case .genealogical:
            return genealogyDiversity(of: individual, in: generation)
        case .fitnessSharing:
            return fitnessSharingDiversity(of: individual, in: generation)
        case .genomeDistanceBased:
            return genomeDistanceBasedDiversity(of: individual, in: generation)
        }
    }
    
    // MARK: 🔒 Private Functions
    
    /// Returns an individual's measured genealogical diversity in the given generation
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
    
    /// Returns an individual's measured genome-distance based diversity in the given generation
    private func genomeDistanceBasedDiversity(of individual: Factory, in generation: Generation) -> Double {
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
    
    /// Returns an individual's measured fitness sharing diversity in the given generation
    private func fitnessSharingDiversity(of individual: Factory, in generation: Generation) -> Double? {
        guard let comparisonIndividual = generation.sortedByFitness.first else { fatalError("Could not find best individual in generation!") }
        if individual == comparisonIndividual {
            return nil
        } else {
            var sumOfWorkstationDistances = 0
            for (i, workstation) in individual.sortedWorkstations.enumerated() {
                let comparisonWorkstation = comparisonIndividual.sortedWorkstations[i]
                sumOfWorkstationDistances += workstation.position.distance(to: comparisonWorkstation.position)
            }
            let averageDistance = Double(sumOfWorkstationDistances) / Double(individual.workstations.count)
            let threshold = Double(individual.layout.size) / 100
            return (averageDistance > threshold) ? nil : (averageDistance / threshold)
        }
    }
    
}
