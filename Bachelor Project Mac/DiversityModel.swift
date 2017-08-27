//
//  DiversityModel.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 26.08.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

enum DiversityModel {
    case fitnessSharing
    case entropyBased
    case genealogical
    
    func getScore(of generation: Generation) -> Int {
        switch self {
        case .fitnessSharing:
            return method1diversity(of: generation)
        case .entropyBased:
            return method2diversity(of: generation)
        case .genealogical:
            return method3diversity(of: generation)
        }
    }
    
    private func method1diversity(of generation: Generation) -> Int {
        return 0
    }
    
    private func method2diversity(of generation: Generation) -> Int {
        return 0
    }
    
    private func method3diversity(of generation: Generation) -> Int {
        return 0
    }
    
}
