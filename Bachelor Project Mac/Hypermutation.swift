//
//  Hypermutation.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 23.06.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

struct Hypermutation: GAPhase {
    
    // MARK: - ⚙️ Computed Properties
    // MARK: 🗝 Private Computed Properties
    
    private var settings: SimulationSettings {
        return SimulationSettings.shared
    }
    
    // MARK: - 📗 Functions
    
    /// Runs the Hypermutation Phase on the given generation
    func execute(on generation: inout Generation) {
        
        if generation.hypermutationShouldTrigger {
            
            let tenPercentOfTargetGenerationSize = settings.populationSize / 10
            var hypermutationResults: [Factory] = []
            
            tenPercentOfTargetGenerationSize.times {
                
                // 1 - Generate new random factory
                let workstationBrakedownNeeded = generation.workstationBreakdownHappened
                let randomFactory = Factory(withBrokenWorkstations: workstationBrakedownNeeded)
                
                // 2 - Insert factory into generation
                generation.insert(randomFactory)
                
                // 3 - Save the factory for the console output
                hypermutationResults.append(randomFactory)
                
            }
            
        }

    }

}

