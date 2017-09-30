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
    
    // MARK: Generation Measurement
    func averageDiversity(for generation: Generation) -> Double {
        var combinedDiversityScore: Double = 0
        for individual in generation.individuals {
            combinedDiversityScore += score(of: individual, in: generation)
        }
        let averageDiversity = combinedDiversityScore / Double(generation.size)
        return averageDiversity
    }
    
    // MARK: Individual Measurement
    func score(of individual: Factory, in generation: Generation) -> Double {
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
    
    private func fitnessSharingDiversity(of individual: Factory, in generation: Generation) -> Double {
        return 0
    }
    
    private func genomDistanceBasedDiversity(of individual: Factory, in generation: Generation) -> Double {
        return 0
    }
    
}
