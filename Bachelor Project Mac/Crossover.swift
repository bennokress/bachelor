//
//  Crossover.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 09.06.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

struct Crossover: Modificator {
    
    func execute(on generation: inout Generation) {
        
        let settings = SimulationSettings.shared
        
        var results: [(parent1: Factory, parent2: Factory, crossover: Factory)] = []
        
        let individuals = generation.parents.shuffled
        for i in 0..<individuals.count {
            
            // 1 - Take two neighboring factories from the selected and shuffled parents
            let factory1 = individuals[i]
            let factory2 = (i-1) < 0 ? individuals[individuals.count - 1] : individuals[i-1]
            
            // 2 - Take the workstations from each of the factories separated and sorted by workstation type
            let newWorkstations = factory1.workstations.sorted { $0.type.rawValue <= $1.type.rawValue }
            let crossoverPartnerWorkstations = factory2.workstations.sorted { $0.type.rawValue <= $1.type.rawValue }
            
            // 3 - Generate a factory layout with the workstations from the first factory to work on
            var crossoverFactoryLayout = settings.getEmptyFactoryGrid
            for workstation in newWorkstations {
                crossoverFactoryLayout.addWorkstation(workstation)
            }
            
            // 4 - Loop through the workstations from the second factory and switch them in for their counterparts of factory 1 randomly
            var neededDNASwitches = 0
            for (index, workstation) in crossoverPartnerWorkstations.enumerated() {
                if Bool.random(trueProbability: settings.crossoverProbability) && crossoverFactoryLayout.isEmptyField(at: workstation.position) {
                    neededDNASwitches += 1
                    let originalWorkstation = newWorkstations[index]
                    
                    // Copy original workstation ID to new workstation
                    let newWorkstation = Workstation(id: originalWorkstation.id, type: workstation.type, at: workstation.position)
                    
                    // Delete original workstation and add new workstation to factory layout
                    crossoverFactoryLayout.swap(originalWorkstation, for: newWorkstation)
                }
            }
            
            // 5 - Compute new genealogyDNA
            let crossoverBitstring = Bitstring(from: factory1.genealogyDNA, and: factory2.genealogyDNA, mergedAfter: neededDNASwitches)
            
            // 6 - Generate new factory from layout and add to generation
            let crossoverFactory = settings.generateFactory(from: &crossoverFactoryLayout, genealogyDNA: crossoverBitstring)
            generation.insert(crossoverFactory)
            
            // 7 - Save result for action output
            results.append((parent1: factory1, parent2: factory2, crossover: crossoverFactory))
            
        }
        
        actionPrint(short: shortActionDescription(for: results), detailed: detailedActionDescription(for: results))
        
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
            actionDescriptionLines.append("  · #\(parent1.genealogyDNA) + #\(parent2.genealogyDNA) ==> #\(child.genealogyDNA)")
//            actionDescriptionLines.append("  · #\(parent1.id) (\(parent1.fitness)) + #\(parent2.id) (\(parent2.fitness)) ==> #\(child.id) (\(child.fitness))")
        }
        return actionDescriptionLines
    }
    
}
