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
        
        for factory in generation {
            
            // 1 - Generate a copy of the factory's layout
            var mutatedFactoryLayout = settings.getEmptyFactoryGrid
            for workstation in factory.workstations {
                mutatedFactoryLayout.addWorkstation(workstation)
            }
            
            // 2 - Loop over the workstations of the factory
            for originalWorkstation in factory.workstations where Bool.random(trueProbability: settings.mutationProbability) {
                
                // Determine all possible empty fields for the mutation of the current workstation
                let possibleNewPositions = originalWorkstation.position.allPositions(inRadius: settings.mutationDistance).filter { mutatedFactoryLayout.isEmptyField(at: $0) }
                
                // Select a new position randomly (and break if no mutation is possible
                guard let newPosition = possibleNewPositions.randomElement else { break }
                
                // Swap the original workstation for the mutated one
                let mutatedWorkstation = Workstation(id: originalWorkstation.id, type: originalWorkstation.type, at: newPosition)
                mutatedFactoryLayout.swap(originalWorkstation, for: mutatedWorkstation)
            }
            
            // 3 - Generate new factory from layout and add to generation
            let mutatedFactory = settings.generateFactory(from: &mutatedFactoryLayout)
            generation.insert(mutatedFactory)
            
        }
        
    }
    
}
