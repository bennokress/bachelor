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
        var combinedDiversityScore: Double = 0
        for individual in generation.individuals {
            combinedDiversityScore += diversityScore(of: individual, in: generation)
        }
        let averageDiversity = combinedDiversityScore / Double(generation.size)
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
    
    private func genealogyDiversity(of individual: Factory, in generation: Generation) -> Double {
        return 0
    }
    
    /// Measuring the pairwise distance of all workstations of the individual in its generation.
    private func fitnessSharingDiversity(of individual: Factory, in generation: Generation) -> Double {
        var sumOfAverageWorkstationDistancesPerIndividual: Double = 0
        for comparisonIndividual in generation.individuals {
            var sumOfPairwiseWorkstationDistances: Double = 0
            for (i, workstation) in individual.sortedWorkstations.enumerated() {
                let comparisonWorkstation = comparisonIndividual.sortedWorkstations[i]
                sumOfPairwiseWorkstationDistances += Double(workstation.position.distance(to: comparisonWorkstation.position))
            }
            let averageWorkstationDistance = sumOfPairwiseWorkstationDistances / Double(individual.workstations.count)
            sumOfAverageWorkstationDistancesPerIndividual += averageWorkstationDistance
        }
        let individualCount = Double(generation.size - 1)
        let diversity = sumOfAverageWorkstationDistancesPerIndividual / individualCount
        return diversity
    }
    
    private func genomDistanceBasedDiversity(of individual: Factory, in generation: Generation) -> Double {
        return 0
    }
    
}
