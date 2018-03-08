//
//  Generation.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 26.08.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

struct Generation {
    
    var settings: SimulationSettings { return SimulationSettings.shared }
    
    var factories: Set<Factory>
    var parents: Set<Factory>
    
    var workstationBreakdownHappened = false
    var averageFitness: Double?
    var averageDiversity: Double?
    
    // MARK: Computed Properties - Factory Specific
    var individuals: [Factory] { return Array(factories) }
    var deterministicIndividuals: Set<Factory> { return factories.filter { $0.fitness < Int.max } }
    var shuffled: [Factory] { return factories.shuffled }
    var sortedByFitness: [Factory] { return factories.sorted { $0.fitness < $1.fitness } }
    var sortedByFitnessAndDiversity: [Factory] { return factories.sorted { $0.getAdaptedFitness(in: self) < $1.getAdaptedFitness(in: self) } }
    
    // MARK: Computed Properties - Metrics
    var size: Int { return factories.count }
    var bestFitness: Int? { return factories.map { $0.fitness }.min() }
    var worstFitness: Int? { return factories.map { $0.fitness }.max() }
    
    // MARK: Computed Properties - Triggers
    var hypermutationShouldTrigger: Bool {
        guard let averageDiversity = averageDiversity else { fatalError("Average Diversity was never measured!") }
        let diversityThreshold = settings.hypermutationThreshold
        return averageDiversity <= diversityThreshold
    }
    
    init(factories: Set<Factory>) {
        self.factories = factories
        self.parents = []
        self.averageFitness = calculateAverageFitness()
        self.averageDiversity = calculateAverageDiversity()
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
    
    mutating func recalculateMeasures() {
        averageFitness = calculateAverageFitness()
        averageDiversity = calculateAverageDiversity()
    }
    
    private func calculateAverageFitness() -> Double {
        return Double(deterministicIndividuals.map { $0.fitness }.reduce(0, +)) / Double(deterministicIndividuals.count)
    }
    
    private func calculateAverageDiversity() -> Double {
        return settings.usedDiversityModel.averageDiversity(for: self)
    }
    
    // TODO: [IMPROVEMENT] Adjust JSON Encoding parameters
    
}
