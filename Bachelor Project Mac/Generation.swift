//
//  Generation.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 26.08.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

struct Generation {
    
    init(factories: Set<Factory>) {
        self.factories = factories
        self.parents = []
        self.averageFitness = calculateAverageFitness()
        self.averageDiversity = calculateAverageDiversity()
    }
    
    // MARK: - 🔨 Static Properties
    
    /// The initial randomly generated Generation
    static var initial: Generation {
        
        let settings = SimulationSettings.shared
        
        settings.nextFactoryID = 1
        var initialFactories: Set<Factory> = []
        
        settings.populationSize.times {
            let factory = Factory.random
            initialFactories.insert(factory)
        }
        
        return Generation(factories: initialFactories)
        
    }
    
    // MARK: - 🔧 Properties
    
    var factories: Set<Factory>
    var parents: Set<Factory>
    
    var averageFitness: Double? // This value calculated at very large expense and is needed a lot, therefore it's saved until recalculation is triggered
    var averageDiversity: Double? // This value calculated at very large expense and is needed a lot, therefore it's saved until recalculation is triggered
    
    var workstationBreakdownHappened = false
    
    // MARK: - ⚙️ Computed Properties
    
    var individuals: [Factory] { return Array(factories) }
    var deterministicIndividuals: Set<Factory> { return factories.filter { $0.fitness < Int.max } }
    var shuffled: [Factory] { return factories.shuffled }
    var sortedByFitness: [Factory] { return factories.sorted { $0.fitness < $1.fitness } }
    var sortedByFitnessAndDiversity: [Factory] { return factories.sorted { $0.getAdaptedFitness(in: self) < $1.getAdaptedFitness(in: self) } }
    
    var size: Int { return factories.count }
    var bestFitness: Int? { return factories.map { $0.fitness }.min() }
    var worstFitness: Int? { return factories.map { $0.fitness }.max() }
    
    var hypermutationShouldTrigger: Bool {
        guard let averageDiversity = averageDiversity else { fatalError("Average Diversity was never measured!") }
        let diversityThreshold = settings.hypermutationThreshold
        return averageDiversity <= diversityThreshold
    }
    
    // MARK: 🗝 Private Computed Properties
    
    private var settings: SimulationSettings {
        return SimulationSettings.shared
    }
    
    // MARK: - 📗 Functions
    // MARK: 🔒 Private Functions
    
    /// Recalculates and saves the average fitness to var averageFitness
    private func calculateAverageFitness() -> Double {
        return Double(deterministicIndividuals.map { $0.fitness }.reduce(0, +)) / Double(deterministicIndividuals.count)
    }
    
    /// Recalculates and saves the average diversity to var averageDiversity
    private func calculateAverageDiversity() -> Double {
        return settings.usedDiversityModel.averageDiversity(for: self)
    }
    
    // MARK: - 📕 Mutating Functions
    
    /// Inserts the given factory into the generation
    mutating func insert(_ factory: Factory) {
        factories.insert(factory)
    }
    
    /// Replaces the specified oldFactory with the given newFactory
    mutating func replace(_ oldFactory: Factory, with newFactory: Factory) {
        guard factories.remove(oldFactory) != nil else { fatalError("Old Factory not found!") }
        insert(newFactory)
    }
    
    /// Declares the given set of factories as parents (saved to var parents)
    mutating func setParents(_ parents: Set<Factory>) {
        self.parents = parents
    }
    
    /// Triggers the recalculation of average diversity and average fitness of the generation
    mutating func recalculateMeasures() {
        averageFitness = calculateAverageFitness()
        averageDiversity = calculateAverageDiversity()
    }
    
}
