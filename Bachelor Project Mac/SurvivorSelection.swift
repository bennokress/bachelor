//
//  SurvivorSelection.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 23.06.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

struct SurvivorSelection: Modificator {
    
    // MARK: - ⚙️ Computed Properties
    
    /// Returns true if duplicates should be eliminated in the selection process as indicated in SimulationSettings
    var duplicateEliminationActivated: Bool {
        return settings.duplicateEliminationActivated
    }
    
    // MARK: 🗝 Private Computed Properties
    
    private var settings: SimulationSettings {
        return SimulationSettings.shared
    }
    
    // MARK: - 📗 Functions
    
    /// Runs the Survivor Selection Phase on the given generation
    func execute(on generation: inout Generation) {
        
        generation.recalculateMeasures()
        let targetPopulationSize = settings.populationSize
        
        var sortedIndividuals = generation.sortedByFitness
        if duplicateEliminationActivated {
            eliminateDuplicates(in: &sortedIndividuals)
        }
        
        generation.factories = Set(sortedIndividuals.prefix(targetPopulationSize))
        
        guard generation.size == targetPopulationSize else { fatalError("Generation size is wrong!") }
        
    }
    
    // MARK: 🔒 Private Functions
    
    /// Removes all factories with identical layouts except one unless falling short of required population size
    private func eliminateDuplicates(in population: inout [Factory]) {
        let populationWithoutFiltering = Set(population)
        let targetPopulationSize = settings.populationSize
        population.filterDuplicates(matching: { $0.hasIdenticalLayout(as: $1) })
        if population.count < targetPopulationSize {
            let necessaryDuplicateCount = targetPopulationSize - population.count
            print("Removing all duplicates from the generation would cause the next generation to fall \(necessaryDuplicateCount) \(necessaryDuplicateCount == 1 ? "factory" : "factories") short of the desired generation size!")
            let necessaryDuplicates = getRandomDuplicates(from: populationWithoutFiltering, ignoring: population, with: necessaryDuplicateCount)
            population.append(contentsOf: necessaryDuplicates)
        }
    }
    
    /// Returns random factories with an identical layout to factories already present in the selection
    private func getRandomDuplicates(from allFactories: Set<Factory>, ignoring alreadySelectedFactories: [Factory], with count: Int) -> [Factory] {
        let duplicateFactoryPool = allFactories.subtracting(alreadySelectedFactories)
        return Array(duplicateFactoryPool.shuffled.prefix(count))
    }
    
}
