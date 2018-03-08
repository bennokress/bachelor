//
//  ParentSelection.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 09.06.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

struct ParentSelection: Modificator {
    
    // MARK: - ⚙️ Computed Properties
    // MARK: 🗝 Private Computed Properties
    
    private var settings: SimulationSettings {
        return SimulationSettings.shared
    }
    
    // MARK: - 📗 Functions
    
    /// Runs the Parent Selection Phase on the given generation
    func execute(on generation: inout Generation) {
        generation.recalculateMeasures()
        let parents = getSelectedIndividuals(from: generation, usingRouletteMode: settings.parentSelectionUsesRouletteMode)
        generation.setParents(parents)
    }
    
    // MARK: 🔒 Private Functions
    
    /// Executes the selection process proportional to the individual's fitness or strictly by fitness as indicated by "usingRouletteMode"
    private func getSelectedIndividuals(from generation: Generation, usingRouletteMode rouletteMode: Bool) -> Set<Factory> {
        
        let useDiversity = settings.parentSelectionUsesDiversity
        let sortedGeneration = useDiversity ? generation.sortedByFitnessAndDiversity : generation.sortedByFitness
        
        if rouletteMode {
            
            guard let bestIndividualInGeneration = sortedGeneration.first else { fatalError("No factories found!") }
            let bestFitnessInGeneration = useDiversity ? bestIndividualInGeneration.getAdaptedFitness(in: generation) : Double(bestIndividualInGeneration.fitness)
            
            // 1 - Build "Roulette Wheel" by adding each factory-ID from the generation n times with n being the inversed and expanded factory fitness
            var rouletteWheel: [Int] = []
            for individual in generation.individuals.sorted(by: { $0.id < $1.id }) {
                let fitness = useDiversity ? individual.getAdaptedFitness(in: generation) : Double(individual.fitness)
                let rouletteWheelFrequency = fitness.rouletteWheelFrequency(relativeTo: bestFitnessInGeneration)
                rouletteWheelFrequency.times {
                    rouletteWheel.append(individual.id)
                }
            }
            
            // 2 - Pick and remove factory IDs randomly from the roulette wheel
            let neededIndividuals = generation.size / 2
            var pickedIDs: [Int] = []
            neededIndividuals.times {
                guard let selectedFactoryID = rouletteWheel.randomElement else { fatalError("No ID found on Roulette Wheel!") }
                rouletteWheel.removeAll(selectedFactoryID)
                pickedIDs.append(selectedFactoryID)
            }
            
            // 3 - Translate the picked IDs to individuals from the generation
            let selectedIndividuals = generation.factories.filter { pickedIDs.contains($0.id) }
            
            return selectedIndividuals
            
        } else {
            return Set(sortedGeneration.prefix(generation.size / 2))
        }
    }
    
}
