//
//  Mutation.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 23.06.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

struct Mutation: Modificator {
    
    func execute(on generation: inout Generation) {
        
        let settings = SimulationSettings.shared
        
        var results: [(original: Factory, mutation: Factory)] = []
        
        for factory in generation.factories {
            
            // 1 - Generate a copy of the factory's layout
            var mutatedFactoryLayout = FactoryLayout.empty
            for workstation in factory.workstations {
                mutatedFactoryLayout.addWorkstation(workstation)
            }
            
            // 2 - Loop over the workstations of the factory
            var neededDNAFlips = 0
            for originalWorkstation in factory.workstations where Bool.random(trueProbability: settings.mutationProbability) {
                
                // Determine all possible empty fields for the mutation of the current workstation
                let possibleNewPositions = originalWorkstation.position.allPositions(inRadius: settings.mutationDistance, inside: factory.layout).filter { mutatedFactoryLayout.isEmptyField(at: $0) }
                
                // Select a new position randomly (and break if no mutation is possible)
                guard let newPosition = possibleNewPositions.randomElement else {
                    break
                }
                
                // Swap the original workstation for the mutated one
                let mutatedWorkstation = Workstation(id: originalWorkstation.id, type: originalWorkstation.type, at: newPosition)
                mutatedFactoryLayout.swap(originalWorkstation, for: mutatedWorkstation)
                neededDNAFlips += 1
            }
            
            // 3 - Compute new genealogyDNA
            let mutationBitstring = Bitstring(from: factory.genealogyDNA, mutatedBitsCount: neededDNAFlips)
            
            // 4 - Generate new factory from layout and add to generation
            let mutatedFactory = Factory(from: &mutatedFactoryLayout, genealogyDNA: mutationBitstring)
            generation.insert(mutatedFactory)
            
            // 5 - Save result for action output
            results.append((original: factory, mutation: mutatedFactory))
        }
        
    }
    
}
