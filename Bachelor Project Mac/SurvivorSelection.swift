//
//  SurvivorSelection.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 23.06.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

struct SurvivorSelection: Modificator {
    
    let mode: SelectionMode
    let duplicateElimination: Bool
    
    func execute(on generation: inout Set<Factory>) {
        
        let targetGenerationSize = SimulationSettings.shared.generationSize
        
        var individuals = Array(generation)
        var duplicateCounter = 0
        if duplicateElimination {
            individuals.filterDuplicates(matching: { $0.layoutHash == $1.layoutHash })
            duplicateCounter = generation.count - individuals.count
            if individuals.count < targetGenerationSize {
                print("Removing all duplicates from the generation caused the next generation to fall short of the desired generation size!")
                let neededDuplicateCount = targetGenerationSize - individuals.count
                let randomElements = individuals.shuffled.prefix(neededDuplicateCount)
                individuals.append(contentsOf: randomElements)
            }
        }
        
        generation = reduce(individuals, toSize: targetGenerationSize)
        
        actionPrint(
            short: shortActionDescription(for: generation.sorted { $0.fitness > $1.fitness }, duplicates: duplicateCounter),
            detailed: detailedActionDescription(for: generation.sorted { $0.fitness > $1.fitness }, duplicates: duplicateCounter)
        )
    }
    
    private func reduce(_ individuals: [Factory], toSize targetSize: Int) -> Set<Factory> {
        var selectedIndividuals: [Factory] = []
        switch mode {
        case .random:
            selectedIndividuals = individuals.shuffled
        case .fitness:
            selectedIndividuals = individuals.sorted { $0.fitness < $1.fitness }
        case .diversity:
            break // FIXME: Add selection implementation
        case .fitnessAndDiversity:
            break // FIXME: Add selection implementation
        }
        return Set(selectedIndividuals.prefix(targetSize))
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
