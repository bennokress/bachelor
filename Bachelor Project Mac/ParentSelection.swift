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
        generation.factories = getSelectedIndividuals(from: generation)
        actionPrint(short: shortActionDescription(for: generation.factories.sorted { $0.fitness < $1.fitness }),
                    detailed: detailedActionDescription(for: generation.factories.sorted { $0.fitness < $1.fitness }))
    }
    
    private func getSelectedIndividuals(from generation: Generation) -> Set<Factory> {
        let selectedIndividuals = SimulationSettings.shared.selectionMode.basedOrder(of: generation.individuals, targetSize: generation.size / 2)
        return Set(selectedIndividuals)
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
