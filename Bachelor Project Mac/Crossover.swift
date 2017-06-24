//
//  Crossover.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 09.06.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

struct Crossover: Modificator {
    
    func execute(on generation: inout Set<Factory>) {
        
        let settings = SimulationSettings.shared
        
        let individuals = Array(generation)
        for i in 0..<individuals.count {
            
            // 1 - Take two neighboring factories
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
            for (index, workstation) in crossoverPartnerWorkstations.enumerated() {
                if Bool.random(trueProbability: settings.crossoverProbability) && crossoverFactoryLayout.isEmptyField(at: workstation.position) {
                    let originalWorkstation = newWorkstations[index]
                    
                    // Copy original workstation ID to new workstation
                    let newWorkstation = Workstation(id: originalWorkstation.id, type: workstation.type, at: workstation.position)
                    
                    // Delete original workstation and add new workstation to factory layout
                    crossoverFactoryLayout.swap(originalWorkstation, for: newWorkstation)
                }
            }
            
            // 5 - Generate new factory from layout and add to generation
            let crossoverFactory = settings.generateFactory(from: &crossoverFactoryLayout)
            generation.insert(crossoverFactory)
            
        }
        
    }
    
}
