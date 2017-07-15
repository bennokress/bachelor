//
//  Mutation.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 23.06.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

struct Mutation: Modificator {
    
    func execute(on generation: inout Set<Factory>) {
        
        let settings = SimulationSettings.shared
        
        var results: [(original: Factory, mutation: Factory)] = []
        
        for factory in generation {
            
            // 1 - Generate a copy of the factory's layout
            var mutatedFactoryLayout = settings.getEmptyFactoryGrid
            for workstation in factory.workstations {
                mutatedFactoryLayout.addWorkstation(workstation)
            }
            
            // 2 - Loop over the workstations of the factory
            for originalWorkstation in factory.workstations where Bool.random(trueProbability: settings.mutationProbability) {
                
                // Determine all possible empty fields for the mutation of the current workstation
                let possibleNewPositions = originalWorkstation.position.allPositions(inRadius: settings.mutationDistance, inside: factory.layout).filter { mutatedFactoryLayout.isEmptyField(at: $0) }
                
                // Select a new position randomly (and break if no mutation is possible
                guard let newPosition = possibleNewPositions.randomElement else { break }
                
                // Swap the original workstation for the mutated one
                let mutatedWorkstation = Workstation(id: originalWorkstation.id, type: originalWorkstation.type, at: newPosition)
                mutatedFactoryLayout.swap(originalWorkstation, for: mutatedWorkstation)
            }
            
            // 3 - Generate new factory from layout and add to generation
            let mutatedFactory = settings.generateFactory(from: &mutatedFactoryLayout)
            generation.insert(mutatedFactory)
            
            // 4 - Save result for action output
            results.append((original: factory, mutation: mutatedFactory))
        }
        
        actionPrint(short: shortActionDescription(for: results), detailed: detailedActionDescription(for: results))
        
    }
    
    private func shortActionDescription(for results: [(original: Factory, mutation: Factory)]) -> String {
        let siblings = results.map { $0.mutation }.sorted { $0.fitness < $1.fitness }
        guard let bestFitness = siblings.first?.fitness, let worstFitness = siblings.last?.fitness else { return "--- Error retreiving fitness ---" }
        return "Mutation produced \(siblings.count) factories with fitness between \(bestFitness) and \(worstFitness)"
    }
    
    private func detailedActionDescription(for results: [(original: Factory, mutation: Factory)]) -> [String] {
        let title = "MUTATION"
        var actionDescriptionLines = ["\n\(title.withAddedDivider("-", totalLength: 56))"]
        for mutation in results.sorted(by: { $0.mutation.fitness < $1.mutation.fitness }) {
            let original = mutation.original
            let sibling = mutation.mutation
            actionDescriptionLines.append("  · #\(original.id) (\(original.fitness)) ==> #\(sibling.id) (\(sibling.fitness))")
        }
        return actionDescriptionLines
    }
    
}
