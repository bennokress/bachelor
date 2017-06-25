//
//  Selection.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 09.06.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

struct ParentSelection: Modificator {
    
    func execute(on generation: inout Set<Factory>) {
        let selectedIndividuals = generation.sorted { $0.fitness < $1.fitness }.firstHalf
        generation = Set(selectedIndividuals)
        actionPrint(short: shortActionDescription(for: selectedIndividuals), detailed: detailedActionDescription(for: selectedIndividuals))
    }
    
    private func shortActionDescription(for generation: [Factory]) -> String {
        guard let bestFitness = generation.first?.fitness, let worstFitness = generation.last?.fitness else { return "--- Error retreiving fitness ---" }
        return "Selected \(generation.count) factories (parents) with fitness between \(bestFitness) and \(worstFitness)"
    }
    
    private func detailedActionDescription(for generation: [Factory]) -> [String] {
        let title = "PARENT SELECTION"
        var actionDescriptionLines = ["\n\(title.withAddedDivider("-", totalLength: 56))"]
        for factory in generation { actionDescriptionLines.append("  · Factory #\(factory.id) with fitness \(factory.fitness)") }
        return actionDescriptionLines
    }
    
}
