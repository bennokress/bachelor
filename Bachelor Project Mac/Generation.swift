//
//  Generation.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 26.08.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

struct Generation {
    
    var factories: Set<Factory>
    
    // MARK: Computed Properties - Factory Specific
    var individuals: [Factory] { return Array(factories) }
    var shuffled: [Factory] { return factories.shuffled }
    var sortedByFitness: [Factory] { return factories.sorted { $0.fitness < $1.fitness } }
    
    // MARK: Computed Properties - Metrics
    var size: Int { return factories.count }
    var diversity: Int {
        return 0
    }
    
    // MARK: Computed Properties - Triggers
    var hypermutationShouldTrigger: Bool {
        let diversityThreshold = SimulationSettings.shared.hypermutationThreshold
        return diversity <= diversityThreshold
    }
    
    // MARK: Functions
    mutating func insert(_ factory: Factory) {
        factories.insert(factory)
    }
    
}
