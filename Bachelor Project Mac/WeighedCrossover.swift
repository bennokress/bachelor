//
//  WeighedCrossover.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 09.06.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

struct WeighedCrossover: Modificator {
    
    func execute(on generation: inout Generation) {
        
        var results: [(parent1: Factory, parent2: Factory, crossover: Factory)] = []

        let sortedFactories = generation.parents.sorted { $0.fitness < $1.fitness }

        let tenPercentOfParentsCount = generation.parents.count / 10

        // 0 - Generation grouped by fitness (best: top 10%, good: next 30%, worst: rest)
        let bestFitnessFactories: [Factory] = Array(sortedFactories[0 ..< tenPercentOfParentsCount]).shuffled()
        let goodFitnessFactories: [Factory] = Array(sortedFactories[tenPercentOfParentsCount ..< (3 * tenPercentOfParentsCount)]).shuffled()
        let worstFitnessFactories: [Factory] = Array(sortedFactories[(3 * tenPercentOfParentsCount) ... (sortedFactories.endIndex - 1)]).shuffled()
        
        // 1 - Crossover from the best group with ...
        for i in 0 ..< bestFitnessFactories.count {
            
            // A - ... each "neighbor"
            let factory = bestFitnessFactories[i]
            let neighbor = (i-1) < 0 ? bestFitnessFactories[bestFitnessFactories.count - 1] : bestFitnessFactories[i-1]
            let bestCrossoverFactory = crossover(factory, and: neighbor)
            generation.insert(bestCrossoverFactory)
            results.append((parent1: factory, parent2: neighbor, crossover: bestCrossoverFactory))
            
            // B - ... with factory at the same position in shuffled good group
            let goodFactoryAtSamePosition = goodFitnessFactories[i]
            let goodCrossoverFactory1 = crossover(factory, and: goodFactoryAtSamePosition)
            generation.insert(goodCrossoverFactory1)
            results.append((parent1: factory, parent2: goodFactoryAtSamePosition, crossover: goodCrossoverFactory1))
            
            // C - ... with factory at the shifted position by 10% of the generation size (= best group size) in shuffled good group
            let goodFactoryAtShiftedPosition = goodFitnessFactories[i + tenPercentOfParentsCount]
            let goodCrossoverFactory2 = crossover(factory, and: goodFactoryAtShiftedPosition)
            generation.insert(goodCrossoverFactory2)
            results.append((parent1: factory, parent2: goodFactoryAtShiftedPosition, crossover: goodCrossoverFactory2))
            
            // D - ... with factory at the inverse position in shuffled good group
            let goodFactoryAtInversePosition = goodFitnessFactories.reversed()[i]
            let goodCrossoverFactory3 = crossover(factory, and: goodFactoryAtInversePosition)
            generation.insert(goodCrossoverFactory3)
            results.append((parent1: factory, parent2: goodFactoryAtInversePosition, crossover: goodCrossoverFactory3))
            
            // E - ... with factory at the same position in shuffled worst group
            let worstFactoryAtSamePosition = worstFitnessFactories[i]
            let worstCrossoverFactory1 = crossover(factory, and: worstFactoryAtSamePosition)
            generation.insert(worstCrossoverFactory1)
            results.append((parent1: factory, parent2: worstFactoryAtSamePosition, crossover: worstCrossoverFactory1))
            
            // F - ... with factory at the shifted position by 10% of the generation size (= best group size) in shuffled worst group
            let worstFactoryAtShiftedPosition = worstFitnessFactories[i + tenPercentOfParentsCount]
            let worstCrossoverFactory2 = crossover(factory, and: worstFactoryAtShiftedPosition)
            generation.insert(worstCrossoverFactory2)
            results.append((parent1: factory, parent2: worstFactoryAtShiftedPosition, crossover: worstCrossoverFactory2))
            
            // G - ... with factory at the inverse position in shuffled worst group
            let worstFactoryAtInversePosition = worstFitnessFactories.reversed()[i]
            let worstCrossoverFactory3 = crossover(factory, and: worstFactoryAtInversePosition)
            generation.insert(worstCrossoverFactory3)
            results.append((parent1: factory, parent2: worstFactoryAtInversePosition, crossover: worstCrossoverFactory3))
            
        }
        
        // 2 - Crossover from the good group with ...
        for i in 0 ..< goodFitnessFactories.count {
            
            // A - ... each "neighbor"
            let factory = goodFitnessFactories[i]
            let neighbor = (i-1) < 0 ? goodFitnessFactories[bestFitnessFactories.count - 1] : goodFitnessFactories[i-1]
            let goodCrossoverFactory = crossover(factory, and: neighbor)
            generation.insert(goodCrossoverFactory)
            results.append((parent1: factory, parent2: neighbor, crossover: goodCrossoverFactory))
            
        }
        
        actionPrint(short: shortActionDescription(for: results), detailed: detailedActionDescription(for: results))
        
    }
    
    private func crossover(_ factory1: Factory, and factory2: Factory) -> Factory {
        
        let settings = SimulationSettings.shared
        
        // 1 - Take the workstations from each of the factories separated and sorted by workstation type
        let newWorkstations = factory1.workstations.sorted { $0.type.rawValue <= $1.type.rawValue }
        let crossoverPartnerWorkstations = factory2.workstations.sorted { $0.type.rawValue <= $1.type.rawValue }
        
        // 2 - Generate a factory layout with the workstations from the first factory to work on
        var crossoverFactoryLayout = settings.getEmptyFactoryGrid
        for workstation in newWorkstations {
            crossoverFactoryLayout.addWorkstation(workstation)
        }
        
        // 3 - Loop through the workstations from the second factory and switch them in for their counterparts of factory 1 randomly
        for (index, workstation) in crossoverPartnerWorkstations.enumerated() {
            if Bool.random(trueProbability: settings.crossoverProbability) && crossoverFactoryLayout.isEmptyField(at: workstation.position) {
                let originalWorkstation = newWorkstations[index]
                
                // Copy original workstation ID to new workstation
                let newWorkstation = Workstation(id: originalWorkstation.id, type: workstation.type, at: workstation.position)
                
                // Delete original workstation and add new workstation to factory layout
                crossoverFactoryLayout.swap(originalWorkstation, for: newWorkstation)
            }
        }
        
        // 4 - Generate new factory from layout and add to generation
        let crossoverFactory = settings.generateFactory(from: &crossoverFactoryLayout)
        
        return crossoverFactory
        
    }
    
    private func shortActionDescription(for results: [(parent1: Factory, parent2: Factory, crossover: Factory)]) -> String {
        let children = results.map { $0.crossover }.sorted { $0.fitness < $1.fitness }
        guard let bestFitness = children.first?.fitness, let worstFitness = children.last?.fitness else { return "--- Error retreiving fitness ---" }
        return "Crossover produced \(children.count) factories with fitness between \(bestFitness) and \(worstFitness)"
    }
    
    private func detailedActionDescription(for results: [(parent1: Factory, parent2: Factory, crossover: Factory)]) -> [String] {
        let title = "CROSSOVER"
        var actionDescriptionLines = ["\n\(title.withAddedDivider("-", totalLength: 56))"]
        for crossover in results.sorted(by: { $0.crossover.fitness < $1.crossover.fitness }) {
            let parent1 = crossover.parent1
            let parent2 = crossover.parent2
            let child = crossover.crossover
            actionDescriptionLines.append("  · #\(parent1.id) (\(parent1.fitness)) + #\(parent2.id) (\(parent2.fitness)) ==> #\(child.id) (\(child.fitness))")
        }
        return actionDescriptionLines
    }
    
}

