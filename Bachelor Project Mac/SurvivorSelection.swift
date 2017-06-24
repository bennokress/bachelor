//
//  SurvivorSelection.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 23.06.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

struct SurvivorSelection: Modificator {
    
    func execute(on generation: inout Set<Factory>) {
        
        let targetGenerationSize = SimulationSettings.shared.generationSize
        
        let sortedIndividuals = generation.sorted { $0.fitness > $1.fitness }.shifted(by: 1)
        var selectedIndividuals = Array(generation.sorted { $0.fitness > $1.fitness }.reversed())
        
        for (index, factory) in sortedIndividuals.enumerated() {
            let comparisonIndex = sortedIndividuals.count - (index + 1)
            let nextFactory = selectedIndividuals[comparisonIndex]
            if factory.fitness == nextFactory.fitness && factory.layout == nextFactory.layout {
//                print("Removing factory with ID \(nextFactory.id) ...")
                selectedIndividuals.remove(at: comparisonIndex)
            }
        }
        
        guard selectedIndividuals.count >= targetGenerationSize else {
            fatalError("Removing all duplicates from the generation caused the next generation to fall short of the desired generation size!")
        }
        
        generation = Set(selectedIndividuals.prefix(targetGenerationSize))
        
    }
    
}
