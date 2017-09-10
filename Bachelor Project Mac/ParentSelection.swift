//
//  ParentSelection.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 09.06.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

struct ParentSelection: Modificator {
    
    func execute(on generation: inout Generation) {
        let parents = getSelectedIndividuals(from: generation, usingRouletteMode: SimulationSettings.shared.parentSelectionUsesRouletteMode)
        generation.setParents(parents)
        actionPrint(short: shortActionDescription(for: parents.sorted { $0.fitness < $1.fitness }),
                    detailed: detailedActionDescription(for: parents.sorted { $0.fitness < $1.fitness }))
    }
    
    private func getSelectedIndividuals(from generation: Generation, usingRouletteMode rouletteMode: Bool) -> Set<Factory> {
        if rouletteMode {
            
            guard let worstFitnessInGeneration = generation.sortedByFitness.first?.fitness else { fatalError("No factories found!") }
            
            // 1 - Build "Roulette Wheel" by adding each factory-ID from the generation n times with n being the inversed and expanded factory fitness
            var rouletteWheel: [Int] = []
            for individual in generation.individuals {
                let fitnessFactor = individual.fitness.inverseAndExpand(by: worstFitnessInGeneration)
                fitnessFactor.times {
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
            
            let sortedGeneration = generation.sortedByFitness
            return Set(sortedGeneration.prefix(generation.size / 2))
            
        }
    }
    
    private func shortActionDescription(for sortedGeneration: [Factory]) -> String {
        guard let bestFitness = sortedGeneration.first?.fitness, let worstFitness = sortedGeneration.last?.fitness else { return "--- Error retreiving fitness ---" }
        return "Selected \(sortedGeneration.count) factories (parents) with fitness between \(bestFitness) and \(worstFitness)"
    }
    
    private func detailedActionDescription(for generation: [Factory]) -> [String] {
        let title = "PARENT SELECTION"
        var actionDescriptionLines = ["\n\(title.withAddedDivider("-", totalLength: 56))"]
        for factory in generation { actionDescriptionLines.append("  · Factory #\(factory.id) with fitness \(factory.fitness)") }
        return actionDescriptionLines
    }
    
}
