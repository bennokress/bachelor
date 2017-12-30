//
//  SurvivorSelection.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 23.06.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

struct SurvivorSelection: Modificator {
    
    var duplicateEliminationActivated: Bool { return SimulationSettings.shared.duplicateEliminationActivated }
    
    func execute(on generation: inout Generation) {
        
        generation.recalculateMeasures()
        let targetGenerationSize = SimulationSettings.shared.generationSize
        let useDiversity = SimulationSettings.shared.selectionUsesDiversity
        
        var sortedIndividuals = useDiversity ? generation.sortedByFitnessAndDiversity : generation.sortedByFitness
        var duplicateCounter = 0
        if duplicateEliminationActivated {
            sortedIndividuals.filterDuplicates(matching: { $0.hasIdenticalLayout(as: $1) })
            duplicateCounter = generation.size - sortedIndividuals.count
            if sortedIndividuals.count < targetGenerationSize {
                let neededDuplicateCount = targetGenerationSize - sortedIndividuals.count
                print("Removing all duplicates from the generation would cause the next generation to fall \(neededDuplicateCount) \(neededDuplicateCount == 1 ? "factory" : "factories") short of the desired generation size!")
                let necessaryDuplicates = getRandomDuplicates(from: generation.factories, ignoring: sortedIndividuals, with: neededDuplicateCount)
                sortedIndividuals.append(contentsOf: necessaryDuplicates)
            }
        }
        
        generation.factories = Set(sortedIndividuals.prefix(targetGenerationSize))
        
        guard generation.size == targetGenerationSize else { fatalError("Generation size is wrong!") }
        
        actionPrint(
            short: shortActionDescription(for: generation.factories.sorted { $0.fitness > $1.fitness }, duplicates: duplicateCounter),
            detailed: detailedActionDescription(for: generation.factories.sorted { $0.fitness > $1.fitness }, duplicates: duplicateCounter)
        )
        
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
        return "\(duplicateEliminationActivated ? "Removed \(duplicates) duplicates\n" : "")Selected \(generation.count) factories (survivors) with fitness between \(bestFitness) and \(worstFitness)"
    }
    
    private func detailedActionDescription(for generation: [Factory], duplicates: Int) -> [String] {
        let title = "SURVIVOR SELECTION"
        var actionDescriptionLines = ["\n\(title.withAddedDivider("-", totalLength: 56))"]
        if duplicateEliminationActivated { actionDescriptionLines.append("  · Removed \(duplicates) duplicates") }
        for factory in generation { actionDescriptionLines.append("  · Selected factory #\(factory.id) with fitness \(factory.fitness) as survivor") }
        return actionDescriptionLines
    }
    
}
