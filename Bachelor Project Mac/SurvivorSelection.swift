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
        let duplicateElimination: Bool
        
        var duplicates: [Factory] = []
        
        let sortedIndividuals = generation.sorted { $0.fitness > $1.fitness }.shifted(by: 1)
        var selectedIndividuals = Array(generation.sorted { $0.fitness > $1.fitness }.reversed())
        
        for (index, factory) in sortedIndividuals.enumerated() {
            let comparisonIndex = sortedIndividuals.count - (index + 1)
            let nextFactory = selectedIndividuals[comparisonIndex]
            if factory.fitness == nextFactory.fitness && factory.hasEqualLayout(as: nextFactory) {
                duplicates.append(nextFactory)
                selectedIndividuals.remove(at: comparisonIndex)
            }
        }
        
        guard selectedIndividuals.count >= targetGenerationSize else {
            fatalError("Removing all duplicates from the generation caused the next generation to fall short of the desired generation size!")
        }
        
        generation = Set(selectedIndividuals.prefix(targetGenerationSize))
        
        actionPrint(
            short: shortActionDescription(for: Array(selectedIndividuals.prefix(targetGenerationSize)), and: duplicates),
            detailed: detailedActionDescription(for: Array(selectedIndividuals.prefix(targetGenerationSize)), and: duplicates)
        )
    }
    
    private func shortActionDescription(for generation: [Factory], and duplicates: [Factory]) -> String {
        guard let bestFitness = generation.first?.fitness, let worstFitness = generation.last?.fitness else { return "--- Error retreiving fitness ---" }
        return "Removed \(duplicates.count) duplicates\nSelected \(generation.count) factories (survivors) with fitness between \(bestFitness) and \(worstFitness)"
    }
    
    private func detailedActionDescription(for generation: [Factory], and duplicates: [Factory]) -> [String] {
        let title = "SURVIVOR SELECTION"
        var actionDescriptionLines = ["\n\(title.withAddedDivider("-", totalLength: 56))"]
        for factory in duplicates { actionDescriptionLines.append("  · Removed duplicate factory #\(factory.id)") }
        for factory in generation { actionDescriptionLines.append("  · Selected factory #\(factory.id) with fitness \(factory.fitness) as survivor") }
        return actionDescriptionLines
    }
    
}
