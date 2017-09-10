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
    func getParameter(for generation: Generation) -> Double {
        switch self {
        case .genealogical:
            return genealogyParameter(for: generation)
        case .fitnessSharing:
            return fitnessSharingParameter(for: generation)
        case .genomDistanceBased:
            return genomDistanceParameter(for: generation)
        }
    }
    
    private func genealogyParameter(for generation: Generation) -> Double {
        return 0
    }
    
    private func fitnessSharingParameter(for generation: Generation) -> Double {
        return 0
    }
    
    private func genomDistanceParameter(for generation: Generation) -> Double {
        return 0
    }
    
    // MARK: Individual Measurement
    func getScore(of generation: Generation) -> Int {
        switch self {
        case .genealogical:
            return genealogyDiversity(of: generation)
        case .fitnessSharing:
            return fitnessSharingDiversity(of: generation)
        case .genomDistanceBased:
            return genomDistanceBasedDiversity(of: generation)
        }
    }
    
    private func genealogyDiversity(of generation: Generation) -> Int {
        return 0
    }
    
    private func fitnessSharingDiversity(of generation: Generation) -> Int {
        return 0
    }
    
    private func genomDistanceBasedDiversity(of generation: Generation) -> Int {
        return 0
    }
    
}
