//
//  DiversityModel.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 26.08.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

enum DiversityModel: String, Encodable {
    case fitnessSharing
    case entropyBased
    case genealogical
    
    // MARK: Generation Measurement
    func getParameter(for generation: Generation) -> Double {
        switch self {
        case .fitnessSharing:
            return fitnessSharingParameter(for: generation)
        case .entropyBased:
            return entropyParameter(for: generation)
        case .genealogical:
            return genealogyParameter(for: generation)
        }
    }
    
    private func fitnessSharingParameter(for generation: Generation) -> Double {
        return 0
    }
    
    private func entropyParameter(for generation: Generation) -> Double {
        return 0
    }
    
    private func genealogyParameter(for generation: Generation) -> Double {
        return 0
    }
    
    // MARK: Individual Measurement
    func getScore(of generation: Generation) -> Int {
        switch self {
        case .fitnessSharing:
            return fitnessSharingDiversity(of: generation)
        case .entropyBased:
            return method2diversity(of: generation)
        case .genealogical:
            return method3diversity(of: generation)
        }
    }
    
    private func fitnessSharingDiversity(of generation: Generation) -> Int {
        return 0
    }
    
    private func method2diversity(of generation: Generation) -> Int {
        return 0
    }
    
    private func method3diversity(of generation: Generation) -> Int {
        return 0
    }
    
}
