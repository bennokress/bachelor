//
//  SurvivorSelection.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 23.06.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

struct SurvivorSelection: Modificator {
    
    let duplicateElimination: Bool
    
    func execute(on generation: inout Set<Factory>) {
        
        let targetGenerationSize = SimulationSettings.shared.generationSize
        
        var individuals = Array(generation)
        var duplicateCounter = 0
        if duplicateElimination {
            individuals.filterDuplicates(matching: { $0.layoutHash == $1.layoutHash })
            duplicateCounter = generation.count - individuals.count
            if individuals.count < targetGenerationSize {
                let neededDuplicateCount = targetGenerationSize - individuals.count
                print("Removing all duplicates from the generation would cause the next generation to fall \(neededDuplicateCount) \(neededDuplicateCount == 1 ? "factory" : "factories") short of the desired generation size!")
                let necessaryDuplicates = getRandomDuplicates(from: generation, ignoring: individuals, with: neededDuplicateCount)
                individuals.append(contentsOf: necessaryDuplicates)
            }
        }
        
        generation = reduce(individuals, toSize: targetGenerationSize)
        
        guard generation.count == targetGenerationSize else { fatalError("Generation size is wrong!") }
        
        actionPrint(
            short: shortActionDescription(for: generation.sorted { $0.fitness > $1.fitness }, duplicates: duplicateCounter),
            detailed: detailedActionDescription(for: generation.sorted { $0.fitness > $1.fitness }, duplicates: duplicateCounter)
        )
    }
    
    private func reduce(_ individuals: [Factory], toSize targetSize: Int) -> Set<Factory> {
        let selectedIndividuals = SimulationSettings.shared.selectionMode.basedOrder(of: individuals, targetSize: targetSize)
        return Set(selectedIndividuals)
    }
    
    private func getRandomDuplicates(from allFactories: Set<Factory>, ignoring alreadySelectedFactories: [Factory], with size: Int) -> [Factory] {
        let duplicateFactoryPool = allFactories.subtracting(alreadySelectedFactories)
        return Array(duplicateFactoryPool.shuffled.prefix(size))
    }
    
    private func bestSelection(from individuals: [Factory], withTargetSize targetSize: Int) -> [Factory] {
        return []
    }
    
    private func shortActionDescription(for generation: [Factory], duplicates: Int) -> String {
        guard let bestFitness = generation.first?.fitness, let worstFitness = generation.last?.fitness else { return "--- Error retreiving fitness ---" }
        return "\(duplicateElimination ? "Removed \(duplicates) duplicates\n" : "")Selected \(generation.count) factories (survivors) with fitness between \(bestFitness) and \(worstFitness)"
    }
    
    private func detailedActionDescription(for generation: [Factory], duplicates: Int) -> [String] {
        let title = "SURVIVOR SELECTION"
        var actionDescriptionLines = ["\n\(title.withAddedDivider("-", totalLength: 56))"]
        if duplicateElimination { actionDescriptionLines.append("  · Removed \(duplicates) duplicates") }
        for factory in generation { actionDescriptionLines.append("  · Selected factory #\(factory.id) with fitness \(factory.fitness) as survivor") }
        return actionDescriptionLines
    }
    
}
