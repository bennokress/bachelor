//
//  Generation.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 26.08.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

struct Generation: Encodable {
    
    var settings: SimulationSettings { return SimulationSettings.shared }
    
    var factories: Set<Factory>
    var parents: Set<Factory>
    
    // MARK: Computed Properties - Factory Specific
    var individuals: [Factory] { return Array(factories) }
    var shuffled: [Factory] { return factories.shuffled }
    var sortedByFitness: [Factory] { return factories.sorted { $0.fitness < $1.fitness } }
    var sortedByFitnessAndDiversity: [Factory] { return factories.sorted { $0.getAdaptedFitness(in: self) < $1.getAdaptedFitness(in: self) } }
    
    // MARK: Computed Properties - Metrics
    var size: Int { return factories.count }
    var averageFitness: Double { return Double(factories.map { $0.fitness }.reduce(0, +)) / Double(factories.count) }
    var bestFitness: Int? { return factories.map { $0.fitness }.min() }
    var worstFitness: Int? { return factories.map { $0.fitness }.max() }
    var averageDiversity: Double { return settings.usedDiversityModel.averageDiversity(for: self) }
    
    // MARK: Computed Properties - Triggers
    var hypermutationShouldTrigger: Bool {
        let diversityThreshold = settings.hypermutationThreshold
        return averageDiversity <= diversityThreshold
    }
    
    init(factories: Set<Factory>) {
        self.factories = factories
        self.parents = []
    }
    
    // MARK: Functions
    mutating func insert(_ factory: Factory) {
        factories.insert(factory)
    }
    
    mutating func replace(_ oldFactory: Factory, with newFactory: Factory) {
        guard factories.remove(oldFactory) != nil else { fatalError("Old Factory not found!") }
        insert(newFactory)
    }
    
    mutating func setParents(_ parents: Set<Factory>) {
        self.parents = parents
    }
    
    // TODO: [IMPROVEMENT] Adjust JSON Encoding parameters
    
}
